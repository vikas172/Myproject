module InvoicesHelper
	def add_work_item_invoice(params,invoice)
		@invoice_work=InvoiceWork.new(:name=>params[:name],:description=>params[:description],:quantity=>params[:quantity],:unit_cost=>params[:unit_cost],:total=>params[:total],:invoice_id=>invoice)
		@invoice_work.save
	end

  def invoice_client_detail(invoice)	
  	if !invoice.client.street1.blank?
			return invoice.client.try(:street1)+" "+invoice.client.try(:city)
    else
    	return ""
    end 
  end

	def client_detail(invoice)
		return invoice.client.initial+ ""+ invoice.client.first_name+" "+invoice.client.last_name
	end

	def client_property(params)
		@client= Client.find(params[:client_id])
		@property=@client.properties
		if !@property.blank?
			return @property.first.try(:street)+" "+@property.first.try(:city)+", "+@property.first.try(:state)+", "+@property.first.try(:zipcode)
		end	
  end 


	def show_tax_invoice(invoice,total_value)
		@invoice=invoice
		@total_value=total_value
			if !@invoice.discount_amount.nil?
	      @tax_calculate= @total_value - @invoice.discount_amount
	    else
	    	@tax_calculate= @total_value
	    end  
      
			if !@invoice.tax.nil?
	    	@tax=(((@tax_calculate)*(@invoice.tax))/100).to_f
	    else
	    	@tax = 0.00
	    end
	end


	def total_amount_invoice(invoice)
		
		 @total=invoice.invoice_works.first.try(:total)
		  if !@total.blank?
		  	@total_all=0
		  	invoice.invoice_works.first.try(:total).each do |total|
		  		@total_all= @total_all + total.to_f
		  	end	
		  	if !invoice.discount_amount.nil?
		  		@total_all=(@total_all - invoice.discount_amount).to_f
		  	end
		  	if !invoice.tax.nil?
		  		@tax = number_with_precision((@total_all*invoice.tax)/100,:precision => 2).to_f
		  		@total_all=(@total_all+@tax).to_f
		  	end
		  	@total_all
		  else
		  	@total_all=0
		  end	 
	end


	def invoice_client_name(invoice)
		return invoice.client.try(:initial)+" "+invoice.client.try(:first_name)+" "+invoice.client.try(:last_name)

	end
  def invoice_client_lname(invoice)
		return invoice.client.try(:last_name) +" "+invoice.client.try(:first_name)+" "+invoice.client.try(:initial)

  end

  #Calculate total mount
	def calulate_job_amount(invoice)
		job_ids = invoice.jobs_id
		@job_work = JobWork.where(job_id: job_ids)
		@invoice_total = 0
		invoice_total = 0
		unless job_ids.blank?
			@invoice_total = @job_work.where(job_id: job_ids).pluck(:total).sum
		end
		InvoiceWork.where(invoice_id: invoice.id).first.total.each do |p|
			invoice_total = invoice_total + p.to_f
		end
		return @invoice_total+invoice_total
	end

	#calculate tax amount for invoice
	def get_tax_amount(invoice)
		job_ids = invoice.jobs_id
		@job_work = JobWork.where(job_id: job_ids)
		@invoice_total = 0
		unless job_ids.blank?
			@invoice_total = @job_work.where(job_id: job_ids).pluck(:total).sum
		end
		tax_amount = (@invoice_total*invoice.tax.to_i)/100
		return tax_amount
	end

	# get total invoice amount
  def get_report_data(status)
    if status.blank?
      @invoices = Invoice.where(:user_id => current_user.id)
    elsif status == "pending"
      @invoices = Invoice.where(:user_id => current_user.id, mark_sent: true, invoice_bad_debt: false)
    elsif status == "paid"
      @invoices = Invoice.where(:user_id => current_user.id, invoice_paid: true)
    elsif status == "bad_debt"
      @invoices = Invoice.where(:user_id => current_user.id, invoice_bad_debt: true)
    else
      @invoices = Invoice.where(:user_id => current_user.id, mark_sent: false)
    end
		@invoice_status_total = 0
		invoice_total = 0
		unless @invoices.blank?
			@invoices.each do |invoice|
				@invoice_status_total = JobWork.where(job_id: invoice.jobs_id).pluck(:total).sum unless invoice.jobs_id.blank?

				InvoiceWork.where(invoice_id: invoice.id).first.total.each do |p|
					invoice_total = invoice_total+p.to_f
				end
			end
		end
		return @invoice_status_total+invoice_total
  end

  #active summary tab
  def get_selected(action)
  	"selected" if action == params[:any]
  end

  def get_selected_default
  	"selected" if params[:any].blank?
  end

  #summary count invoice
  def get_count_invoice(type)
    if type.blank?
      Invoice.where(:user_id => current_user.id).count
    elsif type == "pending"
      Invoice.where(:user_id => current_user.id, mark_sent: true, invoice_bad_debt: false).count
    elsif type == "paid"
      Invoice.where(:user_id => current_user.id, invoice_paid: true).count
    elsif type == "bad_debt"
      Invoice.where(:user_id => current_user.id, invoice_bad_debt: true).count
    else
      Invoice.where(:user_id => current_user.id, mark_sent: false).count
    end
  end

  def fetch_past_due(invoice)
  	  @invoice_due=Date.today
  	  @invoice_pay=invoice.payment.gsub("Net ","").to_i
  	  if !invoice.issued_date.blank?
  	    @invoice_due=invoice.issued_date + @invoice_pay
  	  end
  	  return Date.today <= @invoice_due

  end
  
  def payment_date_calculate(invoice)
  	if invoice.payment== "Upon Reciept"
  		@date = invoice.created_at.strftime("%d-%m-%Y")
  	elsif invoice.payment== "Net 15"
  		@date = invoice.created_at.strftime("%d-%m-%Y").to_date+15
  	elsif invoice.payment== "Net 30"
  		@date = invoice.created_at.strftime("%d-%m-%Y").to_date+30
  	elsif invoice.payment== "Net 45"
  		@date = invoice.created_at.strftime("%d-%m-%Y").to_date+45
  	else
  		@date = invoice.due_date
  	end
  	return @date
  end

  #date formate
  def format_date
  	Date.today.strftime("%d/%m/%Y")
  end

  def email_link_name(invoice)
  	return "Resend E-mail to Client" if invoice.is_mailed
  	return "E-mail to Client"
  end


  def get_job_present(job_id,invoice)
  	@job= Job.find(job_id) rescue ""
  	
  	if @job.blank?
  		invoice.jobs_id.delete(job_id)
  		invoice.save
  		return false
  	else
  		return true
  	end
  end

end
