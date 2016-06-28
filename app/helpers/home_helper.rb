module HomeHelper
	def get_visit_duration(visit)
    time_diff = 0
    date_diff = 0
		date_diff = ((visit.try(:end_date)-visit.try(:start_date)).to_i*24) unless visit.end_date.blank?
		time_diff = ((visit.try(:end_time) - visit.try(:start_time)).to_i.abs)/3600 unless visit.try(:end_time).blank?
		time_diff = date_diff - time_diff unless date_diff.blank?
		return time_diff
	end

  def get_job_report_data(status)
    total=0
    invoice_ids = Array.new
    if status.blank?
      @jobs = Job.where(:user_id => current_user.id, job_type: 'one_off').pluck(:id)
    elsif status == "active"
      @jobs = Job.where(:user_id => current_user.id, job_type: 'one_off').where("end_date >= ? OR complete_on <= ?", Date.today, Date.today).pluck(:id)
    elsif status == "in_progress"
      @jobs = Job.where(:user_id => current_user.id, job_type: 'one_off').where(job_status: "complete").pluck(:id)
      @visit = VisitSchedule.where("job_id NOT IN (?)", @jobs).pluck(:job_id)
      @jobs = @visit
    elsif status == "completed"
    	@jobs = Job.where(:user_id => current_user.id, job_type: 'one_off').where(job_status: "complete").pluck(:id)
    end
    total = JobWork.where(job_id: @jobs).pluck(:total).sum
    return total
  end

  def get_count_job(type)
    @job_condition = Job.where(:user_id => current_user.id, job_type: "one_off") 
    if type.blank?
      @jobs = @job_condition.count
    elsif type == "active"
      @complete_on = @job_condition.where("end_date >= ? OR complete_on <= ?", Date.today, Date.today).count
      return @complete_on
    elsif type == "in_progress"
      @jobs = @job_condition.where(job_status: "complete").pluck(:id)
      @visit = VisitSchedule.where("job_id NOT IN (?)", @jobs).count
      return @visit
    elsif type == "completed"
    	@jobs = @job_condition.where(job_status: "complete").count
    end
  end

  def get_one_off_total(job)
    total = job.job_works.pluck(:total).sum
  end

  #Recurring contracts helper
  def get_recurring_contracts_data(status)
    total=0
    @job_condition = Job.where(:user_id => current_user.id, job_type: "recurring_contract")
    if status.blank?
      @jobs = @job_condition
    elsif status == "active"
      @jobs = @job_condition.where("end_date >= ? OR complete_on <= ?", Date.today, Date.today).pluck(:id)
    elsif status == "completed"
      @jobs = @job_condition.where(job_status: "complete").pluck(:id)
    end
    total = JobWork.where(job_id: @jobs).pluck(:total).sum
    return total
  end

  def get_count_recurring_contracts(type)
    @job_condition = Job.where(:user_id => current_user.id, job_type: "recurring_contract")
    if type.blank?
      @jobs = @job_condition.count
    elsif type == "active"
      @jobs = @job_condition.where("end_date >= ? OR complete_on <= ?", Date.today, Date.today).count
    elsif type == "completed"
      @jobs = @job_condition.where(job_status: "complete").count
    end
  end

  def get_recurring_invoice(job)
    @invoice = Invoice.all
    invoice_recurring_count = 0
      @invoice.each do |invoice|
        unless invoice.jobs_id.blank?
          invoice_recurring_count += 1 if invoice.jobs_id.include?("#{job.id}")
        end
      end
    return invoice_recurring_count
  end

  #get name array for product and service
  def get_name_summary(invoice_works, job_works, quote_works)
    name = []
    invoice_works.all.pluck(:name).each{|p| p.each{|q| name<<q}}
    job_works.all.pluck(:name).uniq{|p| name<<p}
    quote_works.all.pluck(:name).each{|p| p.each{|q| name<<q}}
    return name.uniq
  end

  #get count for quote and invoice for product and service
  def get_count_summary(name, data_work)
    job_qty = 0
    data_work.each do |work|
      if work.name.include?(name)
        work.name.each_with_index{|p,i| job_qty += work.quantity[i].to_i }
      end
    end
    return job_qty
  end

  #get total for quote and invoice for product and service
  def get_total_summary(name, data_work)
    job_total = 0
    data_work.each do |work|
      if work.name.include?(name)
        work.name.each_with_index{|p,i| job_total += work.total[i].to_f }
      end
    end
    return job_total
  end

  #get count for quote and invoice for job work
  def get_job_work_count_summary(name, job_works)
    job_qty = 0
    job_works.each do |work|
      if work.name == name
        job_qty += work.quantity
      end
    end
    return job_qty
  end

  #get total for quote and invoice for job
  def get_job_work_total_summary(name, job_works)
    job_qty = 0

    job_works.each do |work|
      if work.name == name
        job_qty += work.total
      end
    end
    return job_qty
  end

  #Client balance summary 
  def get_client_balance_data(status, client_balance_summary)
    credit_total = 0
    client_balance_summary.each do |client|
      total1 = 0
      ids = client.payment_invoices
      invoice_id = client.invoices.where(invoice_paid: false).pluck(:id)
      InvoiceWork.where(invoice_id: invoice_id).pluck(:total).each{|p| p.each{|q| total1 += q.to_i}}
      pay_balance = client.payment_invoices.where(transaction_type: "payment").pluck(:pay_amount).sum
      initial_balance = client.payment_invoices.where(transaction_type: "initial_balance").first.pay_amount rescue 0
      client_balance = (total1+initial_balance) - pay_balance
      if status=="credit"
        if client_balance < 0
          credit_total += client_balance
        end
      elsif status=="pending"
        if client_balance > 0
          credit_total += client_balance
        end
      end
    end
    return credit_total
  end

  def get_count_client_balance(status, client_balance_summary)
    credit_count = 0
    client_balance_summary.each do |client|
      total1 = 0
      ids = client.payment_invoices
      invoice_id = client.invoices.where(invoice_paid: false).pluck(:id)
      InvoiceWork.where(invoice_id: invoice_id).pluck(:total).each{|p| p.each{|q| total1 += q.to_i}}
      pay_balance = client.payment_invoices.where(transaction_type: "payment").pluck(:pay_amount).sum
      initial_balance = client.payment_invoices.where(transaction_type: "initial_balance").first.pay_amount rescue 0
      client_balance = (total1+initial_balance) - pay_balance
      if status=="credit"
        if client_balance < 0
          credit_count += 1
        end
      elsif status=="pending"
        if client_balance > 0
          credit_count += 1
        end
      end
    end
    return credit_count
  end

  #get client balance
  def get_current_balance(transaction)
    total = 0
    initial_balance = 0
    client = transaction.client unless transaction.blank? rescue ""
    unless client.blank?
      payment_invoices = client.payment_invoices
      invoice_id = client.invoices.where(invoice_paid: false).pluck(:id) unless payment_invoices.blank?
      InvoiceWork.where(invoice_id: invoice_id).pluck(:total).each{|p| p.each{|q| total += q.to_i}}
      pay_balance = payment_invoices.where(transaction_type: "payment").pluck(:pay_amount).sum
      if transaction.transaction_type == "initial_balance"
        initial_balance = client.payment_invoices.where(transaction_type: "initial_balance").first.pay_amount  rescue 0
      end
      return (total+initial_balance) - pay_balance
    end
  end

  #Get paid balance 
  def get_paid_balance(client)
    total_paid  = client.payment_invoices.where("transaction_type !=  ? ", "initial_balance").pluck(:pay_amount).sum
  end

  #get invoice total for client
  def get_total_invoice(client)
    invoice_total = 0
    invoice_id = client.invoices.where(mark_sent: true).pluck(:id)
    InvoiceWork.where(invoice_id: invoice_id).pluck(:total).each{|p| p.each{|q| invoice_total += q.to_i}}
    initial_balance = client.payment_invoices.where(transaction_type: "initial_balance").first.pay_amount rescue 0
    return invoice_total+initial_balance
  end

  def get_client_total_invoice(invoice)
    invoice_total = 0
    invoice.invoice_works.pluck(:total).each{|p| p.each{|q| invoice_total += q.to_i}}
    return invoice_total
  end

  def get_transaction_type_balance(transaction, type)
    if type == "payment"
      return "-#{transaction.pay_amount rescue 0.0}"
    elsif type == "deposit"
      return "-#{transaction.pay_amount rescue 0.0}"
    elsif type == "initial_balance"
      return transaction.pay_amount rescue 0.0
    end
  end

  #get transaction list count
  def get_transactions_data(status, transactions, invoices)
    total = 0
    invoice_id = invoices.where(invoice_paid: false).pluck(:id) unless invoices.blank?
    if status.blank?
      InvoiceWork.where(invoice_id: invoice_id).pluck(:total).each{|p| p.each{|q| total += q.to_i}} rescue 0
      payment_sum = transactions.where("transaction_type != ?", "initial_balance").pluck(:pay_amount).sum rescue 0
      invoice_sum = transactions.where("transaction_type = ?", "initial_balance").pluck(:pay_amount).sum rescue 0 + total rescue 0
      return invoice_sum - payment_sum
    elsif status == "outgoing"
      InvoiceWork.where(invoice_id: invoice_id).pluck(:total).each{|p| p.each{|q| total += q.to_i}} rescue 0
      invoice_sum = transactions.where("transaction_type = ?", "initial_balance").pluck(:pay_amount).sum + total rescue 0
      return invoice_sum
    elsif status == "income"
      invoice_sum = transactions.where("transaction_type != ?", "initial_balance").pluck(:pay_amount).sum rescue 0
      return  invoice_sum
    end

  end

  def get_transaction_count(type)
  end

  #get dashbord current client balance
  def dashboard_current_client_balance(client)
    total = 0
    initial_balance = 0
    unless client.blank?
      payment_invoices = client.payment_invoices
      invoice_id = client.invoices.where(invoice_paid: false).pluck(:id) unless payment_invoices.blank?
      InvoiceWork.where(invoice_id: invoice_id).pluck(:total).each{|p| p.each{|q| total += q.to_i}}
      pay_balance = payment_invoices.where(transaction_type: "payment").pluck(:pay_amount).sum rescue 0
        initial_balance = client.payment_invoices.where(transaction_type: "initial_balance").first.pay_amount  rescue 0
      return (total+initial_balance) - pay_balance 
    end
  end

  #get due invoice total
  def get_due_invoice_income(invoice)
    total = 0
    invoice.invoice_works.pluck(:total).flatten.each{|p| total += p.to_i}
    return total
  end

  #get due invoice total 
  def get_due_invoice_total(params, due_invoice)
    total = 0
    if params.blank?
      due_invoice.each{|invoice| invoice.invoice_works.pluck(:total).flatten.each{|p| 
        total += p.to_i}}
      return total
    elsif params == "7_days"
      @get_invoice = due_invoice.where("due_date < ?", Date.today+7)
      @get_invoice.each{|invoice| invoice.invoice_works.pluck(:total).flatten.each{|p| total += p.to_i}}
      return total
    elsif params == "30_days"
      @get_invoice = due_invoice.where("due_date > ? AND due_date < ?", Date.today+7, Date.today+30)
      @get_invoice.each{|invoice| invoice.invoice_works.pluck(:total).flatten.each{|p| total += p.to_i}}
      return total
    else
      @get_invoice = due_invoice.where("due_date > ?", Date.today+30)
      @get_invoice.each{|invoice| invoice.invoice_works.pluck(:total).flatten.each{|p| total += p.to_i}}
      return total
    end
  end

  #get count due invoice
  def get_due_invoice_count(params, due_invoice)
    if params.blank?
      @get_invoice = due_invoice.count
      return @get_invoice
    elsif params == "7_days"
      @get_invoice = due_invoice.where("due_date < ?", Date.today+7).count
      return @get_invoice
    elsif params == "30_days"
      @get_invoice = due_invoice.where("due_date > ? AND due_date < ?", Date.today+7, Date.today+30).count
      return @get_invoice
    else
      @get_invoice = due_invoice.where("due_date > ?", Date.today+30).count
      return @get_invoice
    end
  end

  def count_outstanding_clients(clients)
    count=0
    clients.each do |client|
      if dashboard_current_client_balance(client)!=0
        count=count+1
      end
    end
    return count
  end

  #get data array for graph
  def get_date_array
    #month_name = Date::ABBR_MONTHNAMES.compact.each_with_index.collect{|m, i| [m]}
    dates = 12.times.each_with_object([]) do |count, array|
      array << [(Date.today.beginning_of_year + count.months).strftime("%Y-%m-%d")]
    end
    return dates
  end

  # Setting  sidebar tabs active
  def setting_selected_sidebar(action)
    return "selected" if action==params[:action]
  end


  def get_last_login(member)
    if !member.member_id.blank?
      @user=User.find(member.member_id)
      if @user.last_sign_in_at==nil
        return "never"
      elsif  @user.last_sign_in_at.strftime("%d/%m/%Y")==Date.today.strftime("%d/%m/%Y")
        return "Today"
      else
       return @user.last_sign_in_at.strftime("%d/%m/%Y")  
      end
    else
      return "never"
    end  
  end

  def get_last_login_main(member)
     @user=User.find(member.id)
    if @user.last_sign_in_at==nil
      return "never"
    elsif  @user.last_sign_in_at.strftime("%d/%m/%Y")==Date.today.strftime("%d/%m/%Y")
      return "Today"
    else
     return @user.last_sign_in_at.strftime("%d/%m/%Y")  
    end  
  end

  def gecode_find(property, geocode)
    @property=property
    geocode=Geocoder.coordinates("#{@property.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{@property.street2}, #{@property.city}, #{@property.country}")
  end

  #get line items
  def get_line_item(line_items)
    items = ""
    line_items.each_with_index do |item,index|
      if index==0
        items = items+""+item
      else
        items = items+","+item
      end
    end
    return items
  end

  #get assigned crew member
  def get_crew(crews)
    member = ""
    if !crews.blank?
      crews.each_with_index do |crew, index|
        if index==0
          member = member+""+crew
        else
          items = member+","+crew
        end
      end
      return member
    end  
  end
end
