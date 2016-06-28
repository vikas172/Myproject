module WorkConfigurationsHelper

	def default_email(params)
		FileUtils.mkdir_p "#{Rails.public_path}/default_emails"
    @invoice = File.open(Rails.root.join("public/default_emails","invoices_subject.txt"), 'w') do |file|
      file.write(params[:work_configuration][:invoice_default_email_subject])
    end 

    @invoice = File.open(Rails.root.join("public/default_emails","invoices_message.txt"), 'w') do |file|
      file.write(params[:work_configuration][:invoice_default_email_message])
    end  

    @quote = File.open(Rails.root.join("public/default_emails","quotes_subject.txt"), 'w') do |file|
      file.write(params[:work_configuration][:quote_default_email_subject])
    end 

    @quote = File.open(Rails.root.join("public/default_emails","quotes_message.txt"), 'w') do |file|
      file.write(params[:work_configuration][:quote_default_email_message])
    end 

    @payment = File.open(Rails.root.join("public/default_emails","payment_subject.txt"), 'w') do |file|
      file.write(params[:work_configuration][:balance_adjustment_default_email_subject])
    end 

    @payment = File.open(Rails.root.join("public/default_emails","payment_message.txt"), 'w') do |file|
      file.write(params[:work_configuration][:balance_adjustment_default_email_message])
    end 

    @statement = File.open(Rails.root.join("public/default_emails","statement_subject.txt"), 'w') do |file|
      file.write(params[:work_configuration][:statement_default_email_subject])
    end 

    @statement = File.open(Rails.root.join("public/default_emails","statement_message.txt"), 'w') do |file|
      file.write(params[:work_configuration][:statement_default_email_message])
    end    

    @signed = File.open(Rails.root.join("public/default_emails","signed_subject.txt"), 'w') do |file|
      file.write(params[:work_configuration][:note_default_email_subject])
    end

    @signed = File.open(Rails.root.join("public/default_emails","signed_message.txt"), 'w') do |file|
      file.write(params[:work_configuration][:note_default_email_message])
    end
	end

	def update_email(params)
		FileUtils.mkdir_p "#{Rails.public_path}/update_emails_#{current_user.id}"
    @invoice = File.open(Rails.root.join("public/update_emails_#{current_user.id}","invoices_subject_#{current_user.id}.txt"), 'w') do |file|
      file.write(params[:work_configuration][:invoice_default_email_subject])
    end 

    @invoice = File.open(Rails.root.join("public/update_emails_#{current_user.id}","invoices_message_#{current_user.id}.txt"), 'w') do |file|
      file.write(params[:work_configuration][:invoice_default_email_message])
    end  

    @quote = File.open(Rails.root.join("public/update_emails_#{current_user.id}","quotes_subject_#{current_user.id}.txt"), 'w') do |file|
      file.write(params[:work_configuration][:quote_default_email_subject])
    end 

    @quote = File.open(Rails.root.join("public/update_emails_#{current_user.id}","quotes_message_#{current_user.id}.txt"), 'w') do |file|
      file.write(params[:work_configuration][:quote_default_email_message])
    end 

    @payment = File.open(Rails.root.join("public/update_emails_#{current_user.id}","payment_subject_#{current_user.id}.txt"), 'w') do |file|
      file.write(params[:work_configuration][:balance_adjustment_default_email_subject])
    end 

    @payment = File.open(Rails.root.join("public/update_emails_#{current_user.id}","payment_message_#{current_user.id}.txt"), 'w') do |file|
      file.write(params[:work_configuration][:balance_adjustment_default_email_message])
    end 

    @statement = File.open(Rails.root.join("public/update_emails_#{current_user.id}","statement_subject_#{current_user.id}.txt"), 'w') do |file|
      file.write(params[:work_configuration][:statement_default_email_subject])
    end 

    @statement = File.open(Rails.root.join("public/update_emails_#{current_user.id}","statement_message_#{current_user.id}.txt"), 'w') do |file|
      file.write(params[:work_configuration][:statement_default_email_message])
    end    

    @signed = File.open(Rails.root.join("public/update_emails_#{current_user.id}","signed_subject_#{current_user.id}.txt"), 'w') do |file|
      file.write(params[:work_configuration][:note_default_email_subject])
    end

    @signed = File.open(Rails.root.join("public/update_emails_#{current_user.id}","signed_message_#{current_user.id}.txt"), 'w') do |file|
      file.write(params[:work_configuration][:note_default_email_message])
    end
	end


  def pdf_setting_value(params,pdf_setting)
    if params[:name]=="quote_show_line_item_unit_costs"
      pdf_setting.quote_show_line_item_unit_costs=params[:data]
    elsif params[:name]=="quote_show_line_item_qty"
      pdf_setting.quote_show_line_item_qty=params[:data]
    elsif params[:name]=="quote_show_line_item_total_costs"
      pdf_setting.quote_show_line_item_total_costs=params[:data]
    elsif params[:name]=="quote_show_totals"
      pdf_setting.quote_show_totals=params[:data]
    elsif params[:name]=="quote_client_signature"
      pdf_setting.quote_client_signature=params[:data]
    elsif params[:name]=="change_quote_to_estimate" 
      pdf_setting.change_quote_to_estimate=params[:data]

    elsif params[:name]=="invoice_show_line_item_qty"
      pdf_setting.invoice_show_line_item_qty=params[:data]
    elsif params[:name]=="invoice_show_line_item_unit_costs" 
      pdf_setting.invoice_show_line_item_unit_costs=params[:data]
    elsif params[:name]=="invoice_show_line_item_total_costs"
      pdf_setting.invoice_show_line_item_total_costs=params[:data]
    elsif params[:name]=="pdf_return_stub" 
      pdf_setting.pdf_return_stub=params[:data]
    elsif params[:name]=="invoice_show_late_stamp"
      pdf_setting.invoice_show_late_stamp=params[:data]
    elsif params[:name]=="invoice_show_account_balance" 
      pdf_setting.invoice_show_account_balance=params[:data] 
    elsif params[:name]=="require_work_order_signature" 
      pdf_setting.require_work_order_signature=params[:data] 
    end  
  end


  def display_pdf_content(value)
    if value== "selected"
      return "display: block;"
    else
      return "display: none;"
    end
  end

  #get email folder name
  def mail_sub(email_info)
    unless Dir.exists?("public/update_emails_#{current_user.id}")
      message_sub = File.read(Rails.root.join("public/default_emails/#{session[:mail_by]}_subject.txt"))
    else 
      message_sub = File.read(Rails.root.join("public/update_emails_#{current_user.id}/#{session[:mail_by]}_subject_#{current_user.id}.txt"))
    end 
    message_sub = message_sub.gsub("{{COMPANY_NAME}}", current_user.company_name ).gsub("{{INVOICE_SUBJECT}}", current_user.company_name ).gsub("{{CURRENT_DATE}}", Date.today.strftime("%m/%d/%Y"))
  end

  def mail_message(email_info)
    unless Dir.exists?("public/update_emails_#{current_user.id}")
      message_body = File.read(Rails.root.join("public/default_emails/#{session[:mail_by]}_message.txt")) 
    else
      message_body = File.read(Rails.root.join("public/update_emails_#{current_user.id}/#{session[:mail_by]}_message_#{current_user.id}.txt"))
    end
    if params[:controller] == "invoices"
      message_body = message_body.gsub("{{CLIENT_NAME}}", email_info.client.first_name ).gsub("{{INVOICE_NUMBER}}", email_info.id.to_s).gsub("{{INVOICE_SUBJECT}}", email_info.subject).gsub("{{INVOICE_TOTAL}}", email_info.tax.to_s ).gsub("{{INVOICE_DUE_DATE}}", "").gsub("{{COMPANY_NAME}}", current_user.company_name ).gsub("{{DEFAULT_EMAIL}}", "" )
    elsif params[:controller] == "quotes"
      message_body = message_body.gsub("{{CLIENT_NAME}}", "" ).gsub("{{COMPANY_NAME}}", current_user.company_name ).gsub("{{QUOTE_TOTAL}}", email_info.discount.to_s ).gsub("{{QUOTE_SENT_DATE}}", "").gsub("{{DEFAULT_EMAIL}}", "" )
    end
  end
end
