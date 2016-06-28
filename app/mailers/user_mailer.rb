class UserMailer < ActionMailer::Base
  default from: "devprojects@mail.com"
  def team_member_invitation(params,user,team_member)
  	@member_full_name=params[:full_name]
  	@member_email=params[:email]
  	@company_name=user.company_name
  	@team_member=team_member
    @marker_color = params[:marker_color].gsub("#","")
  	mail(:to => @member_email, :subject => "You have been added to #{@company_name}")
  end

  def mail_to_client(params,pdf)
    @attach_name=[]
    @attach_url=[]
    if !params[:attachment].blank?
      if !params[:attachment]["assigned_to"].blank?
        params[:attachment]["assigned_to"].each do |attach|
          @attachment=Attachment.find(attach)
          @attach_name << @attachment.image_file_name
          @attach_url << @attachment.image
        end
      end  
    end
    if !@attach_name.blank?
      @attach_name.each_with_index do |name,index|
        attachments["#{name}"] = Paperclip.io_adapters.for(@attach_url[index]).read
      end  
    end
    @invoice = Invoice.find(params[:id])
  	@mail_to = params[:communication][:to]
  	@cc = params[:communication][:cc]
  	@sub = params[:communication][:subject]
  	@message = params[:communication][:message]
    #@amount = @invoice.invoice_works.collect(&:total).flatten.sum
    @amount = eval(@invoice.invoice_works.collect(&:total).flatten.join("+")) 
    attachments['invoice_pdf.pdf']=open("#{Rails.root}/tmp/#{@invoice.id}.pdf").read
  	mail(:to => @mail_to, :subject => @sub, :cc => @cc )
   
  end
   def mail_to_quote(params,pdf)
    @attach_name=[]
    @attach_url=[]
    if !params[:attachment].blank?
      if !params[:attachment]["assigned_to"].blank?
        params[:attachment]["assigned_to"].each do |attach|
          @attachment=Attachment.find(attach)
          @attach_name << @attachment.image_file_name
          @attach_url << @attachment.image
        end
      end  
    end
    if !@attach_name.blank?
      @attach_name.each_with_index do |name,index|
        attachments["#{name}"] = Paperclip.io_adapters.for(@attach_url[index]).read
      end  
    end
    @quote = Quote.find(params[:id])
    @mail_to = params[:communication][:to]
    @cc = params[:communication][:cc]
    @sub = params[:communication][:subject]
    @message = params[:communication][:message]
    #@amount = @invoice.invoice_works.collect(&:total).flatten.sum
    #@amount = eval(@invoice.invoice_works.collect(&:total).flatten.join("+")) 
    attachments['quote_pdf.pdf']=open("#{Rails.root}/tmp/#{@quote.id}.pdf").read
    mail(:to => @mail_to, :subject => @sub, :cc => @cc )
   
  end

  def job_notification(user,job)
    @email= user.email
    @job=job
    @job_client=@job.property.client
    @job_property=@job.property
    @company_name=user.company_name
    mail(:to => @email, :subject => "#{@company_name}: Job Notification ")
  end

  def expense_notification(user,expense)
    @email = user.email
    @expense = expense
    mail(:to => @email, :subject => " Expense Notification ")
  end

  def route_optimization_email(pdf,user) 
    @email = user.email
    attachments['Optimize_route.pdf']=open("#{Rails.root}/tmp/#{user.id}.pdf").read
    mail(:to => @email, :subject => " Optimization route ")
  end

  def notification_visit(user,notification,schedule,general_info)
    if !general_info.blank?
      @service_number = general_info.service_number
    end
    @email=user.email
    @user=user
    @notification=notification
    @schedule=schedule

    mail(:to => @email, :subject => " Your job visit..... ")
  end

  def service_reminder_notification(schedule_reminder,email)
    @schedule_reminder = schedule_reminder
    @email = email
    mail(:to => @email, :subject => "Service Reminder ")
  end

  def client_notification_visit(client,notification,schedule,general_info)
    if !general_info.blank?
      @service_number = general_info.service_number
    end
    @client=client
    @email=client.personal_email
    @notification=notification
    @schedule=schedule
    mail(:to => @email, :subject => "Your job visit date is #{@schedule.start_date}")
  end

  def today_notice_mail_client(client,schedule)
    @client=client
    @email_client=client.personal_email
    @schedule =schedule
    mail(:to => @email_client, :subject => "Notification today schedule")
  end

  def today_notice_mail_user(user,schedule)
    @user=user
    @email_user=user.email
    @schedule =schedule
    mail(:to => @email_user, :subject => "Notification today schedule")
  end

  def email_notification(user_id,params,to,file_names,file_paths)
    @user_id=user_id
    @to = to
    @from = params[:email_notification][:from]
    @body = params[:email_notification][:body]
    if !file_names.blank?
      file_names.each_with_index do |file,index|
        attachments["#{file_names[index]}"] = file_paths[index]
      end
    end
    mail(:from=> @from ,:to=>@to, :subject=> "Notification today schedule")
  end

  def service_item(params,service_item,user)
    @to = user.email
    @notes = service_item.description
    mail(:to=>@to, :subject=> "Customer note for service item")
  end

  def pool_message_filter(property,message)
    @property=property
    @client = property.client
    @message = message
    @to = @client.personal_email
    mail(:to=>@to, :subject=> "Pool Message")
  end

  def property_communication(email_notification)
    @from =email_notification.from
    @to= email_notification.to
    @bcc= email_notification.bcc
    @cc= email_notification.cc
    @subject = email_notification.subject
    @body =email_notification.body
    mail(:from=> @from ,:to=>@to,:bcc=>@bcc,:cc => @cc)
  end

  def teammember_password(user,team_member,params)
    @to = user.email
    @from = team_member.email
    @password =  params[:password_confirmation]
    mail(:from=> @from ,:to=>@to)
  end

  def invoice_remainder(user,team_member)
    @to = team_member.email
    @from = user.email  
    mail(:from=> @from ,:to=>@to)
  end

  def email_to_pdf(user,thepdf)
    @to = "prateekyuvasoft101@gmail.com"
    @from = user.email  
    pdf = open(thepdf).read
    attachments["lead.pdf"]=pdf
    mail(:from=> @from ,:to=>@to)
  end

end
