class IntuitsController < ApplicationController
  before_action :set_qb_service, only: [:create, :edit, :update, :destroy]
  before_action :authenticate_user!
  def authenticate
    callback = oauth_callback_intuits_url
    token = $qb_oauth_consumer.get_request_token(:oauth_callback => callback)
    session[:qb_request_token] = Marshal.dump(token)
    redirect_to("https://appcenter.intuit.com/Connect/Begin?oauth_token=#{token.token}") and return
  end

  def oauth_callback
    at = Marshal.load(session[:qb_request_token]).get_access_token(:oauth_verifier => params[:oauth_verifier])
    session[:token] = at.token
    session[:secret] = at.secret
    session[:realm_id] = params['realmId']
    current_user.update(:qb_token=>session[:token],:qb_secret=>session[:secret],:qb_realm_id=>session[:realm_id])
    flash.notice = "Your QuickBooks account has been successfully linked."
    @msg = 'Redirecting. Please wait.'
    @url = accounts_syncer_qb_show_path
    render 'home/close_and_redirect', layout: false
  end

	def sync_to_quick_book
		set_qb_service
		if params[:syncer][:sync_clients].to_i > 0
			@clientS = current_user.clients
		end

		if params[:syncer][:auto_push_invoices].to_i > 0
			@invoice = Invoice.where(user_id: current_user.id, mark_sent: true)
			@invoice.each do |invoice|
				sync_invoice_to_qb(invoice)
			end
		end

		if params[:syncer][:sync_time_sheets].to_i > 0
			@timesheets = current_user.timesheets.where(:sync_type=>false)
			@team_members=current_user.team_members.where('member_id IS NOT NULL')
			if !@team_members.blank?
				@timesheet1 =[]
				@team_members.each do |member|
					timesheet = Timesheet.where(:user_id=>member.member_id,:sync_type=>false)
					if !timesheet.blank?
						@timesheet1 << timesheet
					end
				end
			end
			if !@timesheets.blank? && @timesheet1
				@times= @timesheets + @timesheet1
			elsif @timesheets.blank?
			   @times = @timesheet1
			 elsif @timesheet1.blank?
			 	@times = @timesheets
			 end
		  if !@times.blank?
				@times.flatten.each do |timesheet|
					sync_timesheet_to_qb(timesheet)
				end
			end
		end

		if params[:syncer][:sync_invoices].to_i > 0
			@invoice = Invoice.where(user_id: current_user.id)
			@invoice.each do |invoice|
				sync_invoice_to_qb(invoice)
			end
		end
		redirect_to :back
	end

	def sync_clients_to_qb(clients)
		set_qb_service
		clients.each do |client|
	    client_qb = Quickbooks::Model::Customer.new
	    client_qb.given_name = client.first_name
	    client_qb.middle_name = client.last_name
	    # client_qb.primary_email_address = client.personal_email
	    address = Quickbooks::Model::PhysicalAddress.new
	    address.line1 = client.street1
	    address.line2 = client.street2
	    address.city = client.city
	    address.country_sub_division_code = client.state
	    address.postal_code = client.zip_code
	    client_qb.billing_address = address
	    @vendor_service.create(client_qb)
	  end
  end

  def qb_exist_name(vendor_service, client_name)
    @is_name=true
    @vendor_service.list.entries.each{|entry| @is_name = false if entry.name == client_name}
    return @is_name
  end

  def closed_qb_account
    current_user.update(:qb_token=> nil,:qb_secret=>nil,:qb_realm_id=>nil)
    redirect_to request.referrer
  end
  

	def sync_invoice_to_qb(invoices)
		total = 0
		@client = invoices.client
		invoice_works = invoices.invoice_works.first
		invoice_works.total.each{|p| total += p.to_i}

		invoice = Quickbooks::Model::Invoice.new
		invoice.customer_id = get_customer_id(@client)
		invoice.txn_date = Date.civil(2013, 11, 20)
		# invoice.doc_number = "1001" # my custom Invoice # - can leave blank to have Intuit auto-generate it
    invoice_works.name.each_with_index do |invoice_work, index|
			line_item = Quickbooks::Model::InvoiceLineItem.new
			line_item.amount = (invoice_works.unit_cost[index].to_i) *(invoice_works.quantity[index].to_i)
			line_item.description =  invoice_works.description[index]
			line_item.sales_item! do |detail|
		  	detail.unit_price = invoice_works.unit_cost[index]
		  	detail.quantity = invoice_works.quantity[index]
		  	detail.item_id = 3 # Item ID here
			end
			invoice.line_items << line_item
		end  
    @invoice_service.create(invoice)
	end


	def sync_timesheet_to_qb(timesheet)

		user=User.find(timesheet.user_id)
		time_activity=Quickbooks::Model::TimeActivity.new
		item_generate(time_activity,timesheet)
		customer_generate(time_activity,timesheet,user)
		employee_generate(time_activity,user)

    time_activity.hourly_rate = 600
    time_activity.hours = timesheet.duration.strftime("%H").to_i
    time_activity.minutes = timesheet.duration.strftime("%M").to_i 
    time_activity.txn_date = timesheet.day
    timesheet.sync_type=true
    timesheet.save
    @service.create(time_activity) rescue "false"
	end

	def customer_generate(time_activity,timesheet,user)

		customer = Quickbooks::Model::Customer.new
		if timesheet.job_id.blank?
			customer.given_name = user.company_name
			if !@vendor_service.query(nil, :page => 1, :per_page => 50).collect(&:given_name).include? user.company_name
			  customers = @vendor_service.create(customer) rescue ""
		  else
		  	id=@vendor_service.query(nil, :page => 1, :per_page => 50).collect{|e| e if e.given_name==user.company_name}.compact.first.id
		  	customers = @vendor_service.fetch_by_id(id)
		  end
			if !customers.blank?
  			time_activity.customer_ref = Quickbooks::Model::BaseReference.new
  			time_activity.customer_ref.value = customers.id
  			time_activity.customer_ref.name = customers.given_name
  		end
    else
    	client=Job.find(timesheet.job_id).property.client
    	customer.given_name= client.first_name
    	customers = @vendor_service.create(customer) rescue ""
			if !customers.blank?
				time_activity.customer_ref = Quickbooks::Model::BaseReference.new
  			time_activity.customer_ref.value = customers.id
  			time_activity.customer_ref.name = customers.given_name
    	end
    end
	end

	def employee_generate(time_activity,user)
		
		time_activity.name_of = "Employee"
    time_activity.employee_ref = Quickbooks::Model::BaseReference.new  
    if !@employee_service.query(nil, :page => 1, :per_page => 50).entries.collect(&:id).include? user.employee_id.to_s  
	    employee = Quickbooks::Model::Employee.new
	    employee.given_name = user.full_name
	    employee.family_name = user.username
	    @employee=@employee_service.create(employee) rescue ""
	    if !@employee.blank?
	    	user.employee_id = @employee.id 
	    	user.save
	    	time_activity.employee_ref.name = @employee.given_name
      	time_activity.employee_ref.value = @employee.id
      end
	  else
     time_activity.employee_ref.name = user.full_name
     time_activity.employee_ref.value = user.employee_id
	  end
	end

	def item_generate(time_activity,timesheet)
	  item = Quickbooks::Model::Item.new
	  item.name= timesheet.custom_category.category rescue ""
	  item.expense_account_ref = Quickbooks::Model::BaseReference.new
	  item.expense_account_ref.name = "Retained Earnings"
	  item.expense_account_ref.value = "4"
	  item.income_account_ref  = Quickbooks::Model::BaseReference.new
	  item.income_account_ref.name  = "Services" 
	  item.income_account_ref.value  = "5"
	  item.inv_start_date=Date.today
	  if @item_service.query(nil, :page => 1, :per_page => 50).entries.collect(&:name).include? item.name
	    id=@item_service.query(nil, :page => 1, :per_page => 50).collect{|e| e if e.name==item.name}.compact.first.id
	    @item = @item_service.fetch_by_id(id)
	  else
	  	@item=@item_service.create(item) rescue ""
	  end
	  time_activity.item_ref = Quickbooks::Model::BaseReference.new
	  if @item.blank?
	    time_activity.item_ref.value = 13
	    time_activity.item_ref.name = "Soil"
	  else
	    time_activity.item_ref.value = @item.id
	    time_activity.item_ref.name = @item.name
	  end  

    time_activity.description = timesheet.note
    if timesheet.billable == true
    	time_activity.billable_status = "Billable"
    end

	end

	private
		def get_customer_id(client)
			customer_id = 59
			# @vendor_service.list.entries.each{|p| customer_id = p.id if p.given_name == client.first_name}
			@vendor_service.query().entries.each do |customer|
				if customer.given_name == client.first_name
          customer_id = customer.id
				end
			end
			return customer_id
		end

    def set_qb_service

      oauth_client = OAuth::AccessToken.new($qb_oauth_consumer, session[:token], session[:secret])
      @vendor_service = Quickbooks::Service::Customer.new
      @vendor_service.access_token = oauth_client
      @vendor_service.realm_id = session[:realm_id]

      @invoice_service = Quickbooks::Service::Invoice.new
			@invoice_service.company_id = "1396814215"
			@invoice_service.access_token = oauth_client
			@invoice_service.realm_id = session[:realm_id]

			@service=Quickbooks::Service::TimeActivity::new
			@service.access_token = oauth_client
      @service.realm_id = session[:realm_id]

      @employee_service = Quickbooks::Service::Employee.new
 			@employee_service.access_token = oauth_client
 			@employee_service.realm_id =session[:realm_id]

      @item_service = Quickbooks::Service::Item.new
		  @item_service.access_token = oauth_client
		  @item_service.realm_id =session[:realm_id]
    end
end