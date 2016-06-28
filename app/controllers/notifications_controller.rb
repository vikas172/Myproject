class NotificationsController < ApplicationController
	protect_from_forgery with: :null_session
	def index
	end

#Client notice and also send notice through task scheduler
	def client_notice
		@jobs=[]
		@schedules=[]
		@clients=Client.all
		@clients.each do |client|
			if !client.properties.blank?
				client.properties.each do |property|
					if !property.jobs.blank?
						property.jobs.each do |job|
							if !job.job_complete 
								@jobs << job
							end
						end
					end
				end
			end
		end
		if !@jobs.blank?
			@jobs.each do |job|
				@schedules << job.visit_schedules
			end
			@schedules=@schedules.flatten
			client_list_obtain(@schedules)
		end
	end

#client_notice method call to get schedules and client sms and email
	def client_list_obtain(schedules)
		schedules.each do |schedule|
			client=schedule.job.property.client
			notification=client.user.notification
			client_sms_email(notification,schedule,client)
		end
	end

#Client notice and also send sms, email 
	def client_sms_email(notification,schedule,client)
		if !notification.blank?
			time=notification.notification_time
			notification_day=notification.notification_day
			start_date=schedule.start_date
			today=Date.today
			if notification_day == "same_day"
				if start_date== today
					if client.preference_notification == "email"
						if ((time.strftime("%I:00%p"))==(Time.now.strftime("%I:00%p")))
							@general_info=client.user.general_info
							UserMailer.client_notification_visit(client,notification,schedule,@general_info).deliver
						end
					elsif client.preference_notification == "sms"
						@general_info= client.user.general_info
						@mobile_number=client.mobile_number
						send_sms_to_team(@general_info,@mobile_number,notification,schedule)
					end
				end
			else
				if ((start_date-1) == (today))
					if notification.client_notification_preference=="email"
						if ((time.strftime("%I:00%p"))==(Time.now.strftime("%I:00%p")))
							@general_info=client.user.general_info
							UserMailer.client_notification_visit(client,notification,schedule,@general_info).deliver
						end
					else
						@general_info= client.user.general_info
						@mobile_number=client.mobile_number
						send_sms_to_team(@general_info,@mobile_number,notification,schedule)
					end	
				end
			end
		end
	end

#Task schedular team member notice
	def team_member_notice
		@schedules=[]
		@jobs=Job.all
		@jobs.each do |job|
			if !job.job_complete
				@schedules << job.visit_schedules
			end
		end
    @schedules=@schedules.flatten
		if !@schedules.blank?
			@schedules.each do |schedule|
				if !schedule.crew.blank?
					schedule.crew.each do |crew|
						@user=User.find(crew)
						if !@user.blank?
							if @user.user_type=="user"
								@user_admin= TeamMember.find_by_member_id(@user.id)
	              @mobile_number=@user_admin.mobile_number
								@admin=User.find(@user_admin.user_id)
								@notification=@admin.notification
	              notification_check(@notification,schedule,@mobile_number)
							else
								@mobile_number=@user.phone_number
	              @notification=@user.notification
	              notification_check(@notification,schedule,@mobile_number)
							end
						end	
					end 
				end
			end
		end
	end

#Notification new object created
	def new
		if !current_user.notification
			@notification=Notification.new
		else
			@notification=current_user.notification
			redirect_to edit_notification_path(@notification)
		end
	end

#Create notification and store to database
	def create
		@notification = Notification.new(notification_params)
		@notification.user_id=current_user.id
		@notification.save
		redirect_to new_notification_path
	end

#Edit notification message
	def edit
		@notification=Notification.find(params[:id])
	end

#Update notification method
	def update
		@notification=Notification.find(params[:id])
		@notification.update(notification_params)
		redirect_to new_notification_path
	end

#Team member notice method call the notifictaion check
	def notification_check(notification,schedule,mobile_number)
		@notification=notification
		if !@notification.blank?
			@time=@notification.notification_time
			@start_date=schedule.start_date
			@today=Date.today
			@mobile_number=mobile_number
			@notification_day=@notification.notification_day
			if @notification_day == "same_day"
				if @start_date == @today
					if @notification.team_notification_by =="email"
						if ((@time.strftime("%I:00%p"))==(Time.now.strftime("%I:00%p")))
							@general_info= @user.general_info
							UserMailer.notification_visit(@user,@notification,schedule,@general_info).deliver
						end
					else		
						@general_info= @user.general_info
            send_sms_to_team(@general_info,@mobile_number,@notification,schedule)
 					end	
				end
			else
				if ((@start_date-1) == (@today))
					if @notification.team_notification_by =="email"
						if ((@time.strftime("%I:00%p"))==(Time.now.strftime("%I:00%p")))
							UserMailer.notification_visit(@user,@notification,schedule).deliver
						end
					else
						@general_info= @user.general_info
						send_sms_to_team(@general_info,@mobile_number,@notification,schedule)
					end	
				end
			end	
		end
	end

  def notify_same_day
  end

#client_sms_email method call thios method to send sms to team member 
	def send_sms_to_team(general_info,mobile_number,notification,schedule)
		@general_info=general_info
		if !@general_info.blank?
		  if !@general_info.service_number.blank?
		    @from= @general_info.service_number
		    @twilio_client = Twilio::REST::Client.new ENV["account_sid"],ENV["auth_token"]
		    if ((!@from.blank?) && (!mobile_number.blank?))
		    	sms_content=notification.team_sms.to_s.gsub("{DATE}",schedule.start_date.to_s).gsub("{TIME}",notification.notification_time.strftime("%I:00%p")).gsub("{SERVICE NUMBER}",@from).gsub("{{COMPANY_NAME}}",@user.company_name)
		    	@twilio_client.account.sms.messages.create({:from => @from, :to =>mobile_number , :body =>sms_content})  
		  	end
		  end
		end
	end
	def invoice_mail
		@invoice = Invoice.where(:status=>"false")
		@invoice.each do |invoice|
			user = User.find(invoice.user_id)
			if user.user_type == "admin"
				@custom_value = CustomDefault.where(:user_id=>user.id)
				@custom_value.each do |custom|
					if custom.remainder==true
						team_members = user.team_members
						team_members.each do |team_member|
							UserMailer.invoice_remainder(user,team_member).deliver
						end
					end
				end
			end
		end
	end
	private
	  def notification_params
  	  params.require(:notification).permit(:notification_day, :notification_time, :team_mobile_number, :team_notification_by, :team_notification_preference, :client_mobile_number, :client_notification_by,:client_notification_preference,:user_id,:team_email,:team_sms,:client_email,:client_sms)
  	end

end
