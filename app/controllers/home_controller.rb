class HomeController < ApplicationController
  layout "new_layout" ,only: []
  layout "new_design_layout" ,only:[:index,:tour,:blog,:contact,:pricing,:about_us]
  include JobsHelper
  include ConversationsHelper
  require 'open_weather'
  before_action :authenticate_user!, except: [:first_login,:index,:tour,:pricing,:blog,:contact,:call,:connect]
  protect_from_forgery :except => ["call"]

  def pricing
  end

  def tour
  end

  def blog
  end

  def contact
  end

  def add_new_custom_field
  end
  def company_edit

    user = User.find(params[:company_id]) 
    user.company_name = params[:company_name]
    user.save
    render :nothing => true
  end
  def setup_complete
    current_user.setup_complete =true
    current_user.save
    redirect_to dashboard_path
  end

  def custom_field_delete
    @custom=CustomField.find(params[:id])
    @custom.delete
    redirect_to request.referrer
  end

  def cancel_account
    if current_user.cancel_account==false
      current_user.update(:cancel_account=>true)
    else
      current_user.update(:cancel_account=>false)
    end  
  end

  #show payment popup on dashboard
  def client_payment
    @payment_invoice = PaymentInvoice.new
    @client = Client.find(params[:client_id])
    @client_initial_balance = @client.payment_invoices.where(transaction_type: "initial_balance")
  end

  def payment_update
    @payment_invoice = PaymentInvoice.find(params[:id])
    @payment_invoice.update(payment_invoice_params)
  end

  #client payment
  def payment
    @client = Client.find(params[:payment_invoice][:client_id])
    @payment = @client.payment_invoices.create(payment_invoice_params)
    redirect_to :back
  end

  def work_items
    @services_all=ServiceProduct.where(:user_id=>current_user.id,:item_type=>"service")
    @products_all=ServiceProduct.where(:user_id=>current_user.id,:item_type=>"product")
  end

  def index
    if !current_user.nil?
      if !request.referer.blank?
        #if request.referer.include? "sign_up"
        if request.referer.include? "check_validate"
          if current_user.user_type =="admin"
            default_client_property
          end
        end
      end
     redirect_to dashboard_path
    end
  end

  def reports
    if current_user.user_type=="admin"
    else
      redirect_to dashboard_path , notice: 'You are not authorized to access this page.'
    end
  end

  def admin_address(crew,property,address,user)
    if !crew.blank?
      crew.each do |id|
        address  << "#{property.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{property.city rescue ""}, #{property.country rescue ""} "
        user << User.find(id)
     end
    else
      user << User.find(current_user.id)
      address  << "#{property.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{property.city}, #{property.country} "
    end
     @users= user.collect(&:marker_color) 
  end

  def user_address(crew,property,address,user)
    if !crew.blank?
      crew.each do |id|
        if (current_user.id == id.to_i)
          address  << "#{property.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{property.city}, #{property.country} "
          user << User.find(id)
        end
      end
    end
    @users= user.collect(&:marker_color)
  end



  def add_client_marker(waypoint_geo1)
    @waypoint_geo1=waypoint_geo1
    @clients=current_user.clients
    if !@clients.blank?
      @clients.each do |client|
        @waypoint_geo1 << "#{client.try(:street1)},#{client.try(:city)},#{client.try(:state)},#{client.try(:zip_code)}"
      end
    end
  end

  def sms_notification_time
    sms_dashboard_center
    if !@receive_messages.blank?
      if !@message_notifications.blank?
        current_user.message_notify=@receive_messages.first.date_created
        current_user.save
      end  
    end
  end

  def call
    @user= User.find(params[:user_id]) if params[:user_id]
    if !@user.blank?
      general_info = @user.general_info
      number = general_info.service_number
      contact = Contact.new
      contact.phone = params["PhoneNumber"]
        @client = Twilio::REST::Client.new $account_sid, $auth_token
        if !number.blank?
          call = @client.account.calls.create(:url => "http://5f0d146e.ngrok.com/connect?number=#{number}",
          :to => contact.phone,
          :from =>number)
          @msg = { :message => 'Phone call incoming!', :status => 'ok' }
          render :json => @msg 
        else
          redirect_to :back
        end  
    else
      redirect_to :back
    end    
  end

  def connect
    response = Twilio::TwiML::Response.new do |r|
       r.Say 'Hello test this its working.'  
    
     r.Dial callerId: '+19163479248' do |d|
        d.Client 'jenny'
      end
    end
    render text: response.text
  end

  #Dialog box for all time jobs on dash board 
  def open_job_dialog
    @job = Job.find(params[:id])
    @team_member = current_user.team_members
    @property = @job.property
    @client = @property.client
    @schedule = @job.visit_schedules
  end

  #Client report summary 
  def client_list
  	@properties = Property.where(:user_id=>current_user.id)
    @clients = Client.where(:user_id=>current_user.id)
  end

  #Job report summary 
  def job_list
    @date_condition = Job.quotes_report_summary(params[:report])
    @jobs_summary = jobs_summary_condition(@date_condition)
  end 

  def jobs_report_summary
    @date_condition = Job.quotes_report_summary(params[:report])
    @jobs_summary = jobs_summary_condition(@date_condition)
  end

  #Recurring Contracts job summary
  def recurring_contracts
    @date_condition = Job.quotes_report_summary(params[:report])
    @contracts_summary = recurring_contracts_summary_condition(@date_condition)
  end

  def recurring_contracts_summary
    @date_condition = Job.quotes_report_summary(params[:report])
    @contracts_summary = recurring_contracts_summary_condition(@date_condition)
  end

  # Product and services summary
  def products_and_services
    @jobs = current_user.jobs.pluck(:id)
    @invoices = current_user.invoices.pluck(:id)
    @quotes = current_user.quotes.pluck(:id)
    @invoice_works = InvoiceWork.where(invoice_id: @invoices).quotes_report_summary(params[:report])
    @job_works = JobWork.where(job_id: @jobs).quotes_report_summary(params[:report])
    @quote_works = QuoteWork.where(quote_id: @quotes).quotes_report_summary(params[:report])
  end

  def products_and_services_summary
    @jobs = current_user.jobs.pluck(:id)
    @invoices = current_user.invoices.pluck(:id)
    @quotes = current_user.quotes.pluck(:id)
    @invoice_works = InvoiceWork.where(invoice_id: @invoices).quotes_report_summary(params[:report])
    @job_works = JobWork.where(job_id: @jobs).quotes_report_summary(params[:report])
    @quote_works = QuoteWork.where(quote_id: @quotes).quotes_report_summary(params[:report])
  end

  #Quotes report summary 
  def quote_list
    @date_condition = Quote.quotes_report_summary(params[:any], params[:report])
    @quotes_summary = quotes_summary_condition(@date_condition)
  end

  def quotes_report_summary
    @date_condition = Quote.quotes_report_summary(params[:any], params[:report])
    quotes_summary_condition(@date_condition)
  end

  #Transactions list summary
  def transactions
    @date_condition = PaymentInvoice.transactions_summary_condition(params[:report])
    @invoices = Invoice.get_summary_condition(params[:any], params[:report]).where(mark_sent: true) unless params[:any] == "income"
    @transactions_summary = transactions_summary_condition(@date_condition)
  end

  def transactions_report_summary
    @date_condition = PaymentInvoice.transactions_summary_condition(params[:report])
    @invoices = Invoice.get_summary_condition(params[:any], params[:report]).where(mark_sent: true) unless params[:any] == "income"
    @transactions_summary = transactions_summary_condition(@date_condition)
  end

  #Invoices report summary 
  def invoice_list
    @date_condition = Invoice.get_summary_condition(params[:any], params[:report])
    summary_condition(@date_condition)
  end

  def get_summary_report
    @date_condition = Invoice.get_summary_condition(params[:any], params[:report])
    summary_condition(@date_condition)
  end

  #visits report summary 
  def visits_list
    @date_condition = VisitSchedule.visits_report_summary(params[:report])
    @visits_summary = visits_summary_condition(@date_condition)
  end

  def visits_report_summary
    @date_condition = VisitSchedule.visits_report_summary(params[:report])
    @visits_summary = visits_summary_condition(@date_condition)
  end

  #Client balance summary
  def client_balance
    @date_condition = Client.clients_balance_summary(params[:report])
    @client_balance_summary = clients_balance_sumary(@date_condition)
  end

  def client_balance_sumary
    @date_condition = Client.clients_balance_summary(params[:report])
    @client_balance_summary = clients_balance_sumary(@date_condition)
  end

  #Project income under management
  def projected_income
    @projected_income_summary = projected_summary(params[:any])
    @due_total_invoice = projected_summary("")
  end

  def projected_income_summary
  end

  # aged receivables under management tab
  def aged_receivables
  end

  #email communication
  def email_communication
    @date_condition = Communication.emails_communication_summary(params[:report])
    @emails_communication_summary = emails_communication_sumary(@date_condition)
  end

  #email communication summary filter
  def emails_communication_summary
    @date_condition = Communication.emails_communication_summary(params[:report])
    @emails_communication_summary = emails_communication_sumary(@date_condition)
  end

  #open popup for emails 
  def open_email
    @communication = Communication.find(params[:id])
  end

  #Add on summary
  def expenses
    @date_condition = Expense.expenses_report_summary(params[:report])
    @expense_summary = expenses_summary(@date_condition)
  end

  def expenses_report_summary
    @date_condition = Expense.expenses_report_summary(params[:report])
    @expense_summary = expenses_summary(@date_condition)
  end

  def product_service_edit
  end

  def product_service
    ServiceProduct.create(item_params)
    redirect_to work_items_path
  end

  def users
    if (current_user.user_type=="admin")
      @team_members_active=current_user.team_members.where(:active=>true)
      @team_members_deactive=current_user.team_members.where(:active=>false)
    end
  end

  def user_new
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"User")
  end

  def home_create_user
    unless params[:full_name].blank? || params[:email].blank? || params[:mobile_number].blank? || params[:last_name].blank?
      @user=current_user
      add_user_information(params)
      if !@team_member.id.blank?
        UserMailer.team_member_invitation(params,@user,@team_member.id).deliver
        session[:sucess_team_member]= "#{@team_member.email} has been happily invited to CopperService."
        redirect_to users_path
      else
        session[:team_member_error]= @team_member.errors.messages
        redirect_to "/home/users/new"
      end  
    else
      @user=current_user
      add_user_information(params)
      session[:team_member_error]= @team_member.errors.messages
      redirect_to "/home/users/new"
    end

  end

  def first_login
    @user=User.new
  end

  def member_edit
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"User")
    @team_member=TeamMember.find(params[:id])
    @custom_field_data=@team_member.custom_field
    @permission=@team_member.permission
  end

  def member_update
    @team_member=TeamMember.find(params[:id])
    @user = User.find(@team_member.member_id)
    @admin = @team_member.user
    @team_member.custom_field=params[:custom_field]
    @team_member.is_admin=params[:permission]["company_admin"]
    @team_member.save
    @team_member.update(:full_name=>params[:full_name],:email=>params[:email],:phone_number=>params[:phone_number],:street=>params[:street],:city=>params[:city],:state=>params[:state],:zipcode=>params[:zipcode],:ssn_number=>params[:ssn_number])
    #@team_member.update(:full_name=>params[:full_name],:email=>params[:email],:phone_number=>params[:phone_number],:street=>params[:street],:city=>params[:city],:state=>params[:state],:zipcode=>params[:zipcode],:ssn_number=>params[:ssn_number],:login_access=>access_login(params[:login_access]))
    if params[:password].present?
      @user.update(:password=>params[:password],:password_confirmation=>params[:password_confirmation])   
      UserMailer.teammember_password(@user,@admin,params).deliver
    end
    @team_member.permission.update(:permission_show_pricing=>check_pricing_value(params[:permission][:permission_show_pricing]),:permission_client_properties=>params[:permission][:permission_client_properties],:permission_quotes=>params[:permission][:permission_quotes],:permission_invoices=>params[:permission][:permission_invoices],:permission_jobs=>params[:permission][:permission_jobs],:permission_note_attachment=>params[:permission][:permission_note_attachment],:permission_reports=>params[:permission][:permission_reports], :to_dos=> params[:permission][:to_dos], :company_admin=> params[:permission][:company_admin])  
    flash[:notice] = "Member update successfully!"
    redirect_to users_path 
  end

  def deactive
    @team_member=TeamMember.find(params[:id])
    if params[:any]=="reactivate"
      @team_member.active=true
    else
      @team_member.active=false
    end
    @team_member.save
    redirect_to users_path 
  end 

  # team member show
  def user_show
    @team_member=TeamMember.find(params[:id])
  end

  # team member delete
  def user_delete
    @team_member=TeamMember.find(params[:id])
    @team_member.destroy
    redirect_to users_path
  end

  #quick book show response
  def qb_show
  end

  #intute bluedot
  def bluedot
    access_token = session[:token]
    access_secret = session[:secret]
    consumer = OAuth::AccessToken.new($qb_oauth_consumer, access_token, access_secret)
    response = consumer.request(:get, "https://appcenter.intuit.com/api/v1/Account/AppMenu")
    if response && response.body
     html = response.body
     render(:text => html) and return
    end
  end

  def company_brand
    @company=Company.find_by_user_id(current_user.id)
    @general_info=current_user.general_info
  end

  def company_brand_create
    @company=Company.find_by_user_id(current_user.id)
    if @company.blank?
      @company=Company.new(company_params)
      @company.street= params[:street]
      @company.city= params[:city]
      @company.state= params[:state]
      @company.zipcode= params[:zipcode]
      @company.save
    else
      @company.update(company_params)
      @company.update(:street=>params[:street],:city=>params[:city],:state=>params[:state],:zipcode=>params[:zipcode])
      if params[:company][:company_logo_show].nil? 
        @company.company_logo_show=false
        @company.save
      end
    end
      require 'RMagick'
      @company.company_logo = params[:company][:company_logo]
      @company.save
      attachment=@company.company_logo
      if (!params[:jcrop_holder_width].blank? && !params[:jcrop_holder_height].blank? )
        image_src =  Magick::Image.from_blob(params[:company][:company_logo].read)
        image_resize_coordinates = image_src.first.resize_to_fill(params[:jcrop_holder_width].to_i, params[:jcrop_holder_height].to_i)
        cropped_image = image_resize_coordinates.crop(params[:user_edit][:crop_x].to_i,params[:user_edit][:crop_y].to_i,params[:user_edit][:crop_w].to_i,params[:user_edit][:crop_h].to_i)
        list = Magick::ImageList.new
        list << cropped_image
         
        image_name = "profile"+""+Time.now.strftime('%Y%H%M%S').to_s+".jpg"
        attach =list.write(url = "#{Rails.root}/tmp/"+image_name)
        @company.company_logo = File.open(url)
        #current_user.update_attributes(:company_logo_show => current_user.company_logo_show)

        @company.save
      end  
    redirect_to "/work_configuration/edit"
  end

  def custom_field  
    @custom_clients=CustomField.where(:user_id=>current_user.id,:applies_to=>"Clients")
    @custom_items=CustomField.where(:user_id=>current_user.id,:applies_to=>"Items")
    @custom_parts=CustomField.where(:user_id=>current_user.id,:applies_to=>"Parts")
    @custom_properties=CustomField.where(:user_id=>current_user.id,:applies_to=>"Properties")
    @custom_jobs=CustomField.where(:user_id=>current_user.id,:applies_to=>"Jobs")
    @custom_quotes=CustomField.where(:user_id=>current_user.id,:applies_to=>"Quotes")
    @custom_invoices=CustomField.where(:user_id=>current_user.id,:applies_to=>"Invoices")
    @custom_team_members=CustomField.where(:user_id=>current_user.id,:applies_to=>"User")
  end

  def custom_field_create
    @custom_field=CustomField.new(custom_params) 
    @custom_field.value_type=params[:custom_field][:value_type]
    @custom_field.save
    redirect_to custom_fields_path
  end

  # custom field edit action
  def custom_field_edit
    @custom_field=CustomField.find(params[:custom_id])
  end

  #custom field update
  def custom_field_update
    @custom_field=CustomField.find(params[:custom_field_id])
    @custom_field.update(:name=>params[:custom_field][:name],:value_type=>params[:custom_field][:value_type])
    redirect_to custom_fields_path
  end
  
  def general_account
    @general_account=GeneralInfo.find_by_user_id(current_user.id)
    if @general_account.blank?
      @general_account= GeneralInfo.new
    end
    buy_a_number(params)
  end

  def buy_a_number(params)
    @general_info=current_user.general_info
    if !params[:area_code].blank?
      client = Twilio::REST::Client.new $account_sid, $auth_token
      begin
        @number = client.account.incoming_phone_numbers.create(
                    :area_code => params[:area_code])
        '<b>Success!</b> You now own the number <b>' + @number.phone_number + '</b>.'
      rescue StandardError => e
        '<b>Sorry!</b> ' + e.message + '.'
        @message=e.message
      end
    end  
    if !@number.blank?  
      @general=current_user.general_info
      if !@general.blank?
        @general.service_number= @number.phone_number rescue ""
        @general.area_code=params[:area_code] if !params[:area_code].blank?
        @general.save
      else
        @general=GeneralInfo.new
        @general.service_number= @number.phone_number rescue ""
        @general.area_code=params[:area_code] if !params[:area_code].blank?
        @general.user_id=current_user.id
        @general.save
      end  
    end
    @general_info=GeneralInfo.find_by_user_id(current_user.id)
  end

  def general_account_update
    @general_account=GeneralInfo.find_by_user_id(current_user.id)
    if @general_account.blank?
      @general_info=GeneralInfo.new(general_params)
      @general_info.week_day= params[:week_day]
      @general_info.save
    else
      @general_account.update(general_params)
      @general_account.week_day= params[:week_day]
      @general_account.save
    end
    redirect_to accounts_edit_path
  end


  def update_service
    @service=ServiceProduct.find(params[:id])
    @service.update(item_params)
    redirect_to work_items_path
  end

  def delete_service
    @service=ServiceProduct.find(params[:id])
    @service.destroy
    redirect_to work_items_path
  end

  #show payment invoice on manegment tab
  def open_payment_dialog
    @payment_invoice = PaymentInvoice.find(params[:payment_id])
  end

  def open_invoice_dialog
    invoice_total = 0
    @invoice = Invoice.find(params[:invoice_id])
    @invoice.invoice_works.pluck(:total).each{|p| p.each{|q| invoice_total += q.to_i}}
    @total = invoice_total

  end

  private
  def access_login(access)
    if access.nil?
      return false
    else
      return true
    end
  end

  def check_pricing_value(pricing_value)
    if pricing_value.nil?
      return false
    else
      return true
    end  
  end

  def summary_condition(date_condition)
    if params[:any].blank?
      @invoice = date_condition.where(:user_id => current_user.id)
    elsif params[:any] == "pending"
      @invoice = date_condition.where(:user_id => current_user.id, mark_sent: true)
    elsif params[:any] == "paid"
      @invoice = date_condition.where(:user_id => current_user.id, invoice_paid: true)
    elsif params[:any] == "bad_debt"
      @invoice = date_condition.where(:user_id => current_user.id, invoice_bad_debt: true)
    else 
      @invoice = date_condition.where(:user_id => current_user.id, mark_sent: false)
    end
  end

  def quotes_summary_condition(date_condition)
    @quotes_condition = date_condition.where(:user_id => current_user.id)
    if params[:any].blank?
      @quotes = @quotes_condition
    elsif params[:any] == "draft"
      @quotes = @quotes_condition.where(sent: false)
    elsif params[:any] == "pending"
      @quotes = @quotes_condition.where(sent: false, archive: false)
    elsif params[:any] == "sent"
      @quotes = @quotes_condition.where(sent: true)
    elsif params[:any] == "won"
      arr_id = []
      @quotes_id = Job.all.each{|p| arr_id << p.quote_id unless p.quote_id.blank? }
      @quotes = @quotes_condition.where(id: arr_id)
    end
  end

  def visits_summary_condition(date_condition)
    if params[:report].blank?
      @visits = date_condition.where(:user_id => current_user.id)
    elsif params[:report][:completed] == "Yes"
      @visits = date_condition.where(:user_id => current_user.id, job_complete: true)
    elsif params[:report][:completed] == "No"
      @visits = date_condition.where(:user_id => current_user.id, job_complete: false)
    elsif !params[:report][:assigned_to].blank?
      @visits = []
      @visits_data = date_condition.where(:user_id => current_user.id)
      @visits_data.each do |visit|
        @visits << visit if visit.assigned_users.first.split(',').include?(params[:report][:assigned_to]) rescue false
      end
      return @visits
    elsif params[:report] == "contains_line_item"
      @visits = date_condition.where(:user_id => current_user.id)
    else  
      @visits = date_condition.where(:user_id => current_user.id)
    end
  end

  def jobs_summary_condition(date_condition)
    @job_condition = date_condition.where(:user_id => current_user.id, job_type: 'one_off')
    if params[:any].blank?
      @jobs = @job_condition
    elsif params[:any] == "active"
      @jobs = @job_condition.where("end_date >= ? OR complete_on <= ?", Date.today, Date.today)
    elsif params[:any] == "in_progress"
      @visit = VisitSchedule.all.pluck(:job_id)
      @jobs = @job_condition.where(id: @visit, job_status: "complete")
      return @jobs 
    elsif params[:any] == "completed"
      @jobs = @job_condition.where(job_status: "complete")
    end
  end

  def recurring_contracts_summary_condition(date_condition)
    @job_condition = date_condition.where(:user_id => current_user.id, job_type: 'recurring_contract')
    if params[:any].blank?
      @contracts = @job_condition
    elsif params[:any] == "active"
      @contracts = @job_condition.where("end_date >= ? OR complete_on <= ?", Date.today, Date.today)
    elsif params[:any] == "completed"
      @contracts = @job_condition.where(job_status: "complete")
    end
  end

  def clients_balance_sumary(date_condition)
    if params[:any].blank?
      @contracts = date_condition.where(:user_id => current_user.id)
    elsif params[:any] == "credit"
      @contracts = date_condition.where(:user_id => current_user.id)
    elsif params[:any] == "pending"
      @contracts = date_condition.where(:user_id => current_user.id)
    end
  end

  def transactions_summary_condition(date_condition)
    if params[:any].blank?
      @contracts = date_condition.where(:user_id => current_user.id)
    elsif params[:any] == "outgoing"
      @contracts = date_condition.where(:user_id => current_user.id, transaction_type: 'initial_balance')
    elsif params[:any] == "income"
      @contracts = date_condition.where(:user_id => current_user.id, transaction_type: 'payment')
    end
  end

  def projected_summary(params)
    @projected_income  = Invoice.where(:user_id => current_user.id, mark_sent: true, invoice_paid: false)
    if params.blank?
      return @projected_income
    elsif params == "7_days"
      return @projected_income.where("due_date < ?", Date.today+7)
    elsif params == "30_days"
      return @projected_income.where("due_date > ? AND due_date < ?", Date.today+7, Date.today+30)
    else
      return @projected_income.where("due_date > ?", Date.today+30)
    end
  end

  def emails_communication_sumary(date_condition)
    @emails_communication  = date_condition.where(:user_id => current_user.id)
  end

  def expenses_summary(date_condition)
    @expense_summary = date_condition.where(user_id: current_user.id)
  end



    def archived_job
    @jobs_archives=[]
    if current_user.user_type=="admin"
      @jobs=Job.where(:user_id=>current_user.id)
    else
      user_admin_id=TeamMember.find_by_member_id(current_user.id).user_id
      @jobs=Job.where(:user_id=>user_admin_id)
    end
    if !@jobs.blank?
      @jobs.each do |job|
        if job.job_required== "Require Invoice"
          @count=check_job_invoice_genrate(job)
          if @count!= 0
            @jobs_archives<< job
          end
        end
      end
      return @jobs_archives
    end  
  end

    def active_job
    @jobs_active=[]
    if current_user.user_type=="admin"
      @jobs=Job.where(:user_id=>current_user.id)
    else
      user_admin_id=TeamMember.find_by_member_id(current_user.id).user_id
      @jobs=Job.where(:user_id=>user_admin_id)
    end
    if !@jobs.blank?
      @jobs.each do |job| 
      if job.job_required!= "Require Invoice"
          @count=check_job_invoice_genrate(job)
          if ((@count== 0) || (job.start_date == Date.today)) 
            @jobs_active<< job 
          end
        end
      end
      return @jobs_active
    end  
  end

  def requires_job
    @jobs_required=[]
    if current_user.user_type=="admin"
      @jobs=Job.where(:user_id=>current_user.id)
    else
      user_admin_id=TeamMember.find_by_member_id(current_user.id).user_id
      @jobs=Job.where(:user_id=>user_admin_id)
    end
    if !@jobs.blank?
      @jobs.each do |job|
        if job.job_required== "Require Invoice"
          @count=check_job_invoice_genrate(job)
          if @count== 0
            @jobs_required<< job
          end
        end
      end
      return @jobs_required
    end  
  end

  def item_params
    params.require(:work_item).permit(:item_type,:name,:description,:unit_cost,:non_taxable,:user_id,:active)
  end

  def company_params
    params.require(:company).permit(:company_name,:company_phone,:company_email,:company_website,:company_address,:company_logo,:company_logo_show,:user_id,:start_week_on,:street,:city,:state,:zipcode)
  end

  def custom_params
    params.require(:custom_field).permit(:applies_to,:name,:user_id)
  end

   def general_params
    params.require(:general_info).permit(:default_tax,:tax_reg_type,:tax_reg_number,:country,:language,:work_start_day,:work_end_day,:week_day,:user_id,:street1,:street2,:city,:state,:company_phone,:service_tax,:zipcode,:currency)
  end

  def payment_invoice_params
    params.require(:payment_invoice).permit(:pay_amount, :entry_date, :pay_method,:cheque_number, :transaction_number, :confirmation_number, :additional_note, :transaction_type, :client_id, :user_id )
  end

private
   def get_preference_vendors(vendor_setting,pref_vendors)
      if !vendor_setting.preference_vendor.blank?
        vendor_setting.preference_vendor.each do |id|
          p = Vendor.find(id)
          pref_vendors << { name:"#{p.street} , #{p.city} ,#{p.zipcode} , <a href=/vendors/add_preference?vendors=#{p.id}&map=marker data-remote=true>Add Preference</a>", latitude: p.latitude, longitude: p.longitude}
        end
        return pref_vendors
      end
  end
  def vendors_locations
    options = { units: "metric", APPID: WEATHER_APPID }
    res = OpenWeather::Current.city("#{current_user.street} ,#{current_user.city}", options) rescue ""
    @lat = res["coord"]["lat"] rescue "40.73"
    @lng = res["coord"]["lon"] rescue "-73.93"
  end
  def get_alladdress_miles(vendors,vendor)
    if !current_user.street.blank?
      return Vendor.near("#{current_user.street},#{current_user.city},#{current_user.state}", vendor.try(:vendor_miles))
    elsif !current_user.company.blank?
      if !current_user.company.street.blank?
        return Vendor.near("#{current_user.company.street},#{current_user.company.city},#{current_user.company.state}", vendor.try(:vendor_miles))
      else
        get_data_ipaddress(vendor)
      end
    else
      get_data_ipaddress(vendor)
    end 
  end
  def get_vendors_radius(vendor)
      if vendor.blank?
        @radius = 25
        # @icons = "green.png"
      elsif vendor.vendor_miles.blank?
        @radius =25
        @icons = "green-dot.png" if vendor.prefer_marker == "miles"
        @icons = "blue-dot.png" if vendor.prefer_marker == "preference"
      else
        @icons = "green-dot.png" if vendor.prefer_marker == "miles"
        @icons = "blue-dot.png" if vendor.prefer_marker == "preference"
        @radius =vendor.vendor_miles
      end
  end
end

  