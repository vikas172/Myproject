class EmailNotificationsController < ApplicationController
	before_action :authenticate_user!, :except=>[:reply_message,:message_create,:thanks_message]
  protect_from_forgery with: :null_session

	def reply_message
  end	

#chat popup open display name of user or team members
  def chat_popup
      # @users = User.where.not("id = ?",current_user.id).order("created_at DESC")
      if current_user.user_type == "admin"
        @users= current_user.team_members.where('member_id IS NOT NULL')
      else
        @users=[]
        @user = @team_member.user
        @user_team= @team_member.user.team_members.where("member_id!=?",current_user.id)
        @users <<  @user
        if !@user_team.blank?
          @user_team.each do |team|
            @users << User.find(team.member_id)
          end
        end  
        @users = @users.flatten
      end
      @conversations = Chat.involving(current_user).order("created_at DESC")
  end

#Email notification object created
  def new
  	@notification=EmailNotification.new
  	@users=current_user.team_members
  end

#Email notification with attachment
  def create
    
    if !params[:email_notification][:to].first.blank?
      params[:email_notification][:to].each do |to|
        @notification = EmailNotification.new(email_params)
        @notification.to = to
        @notification.image =params[:email_notification][:image]
        file_names= []
        file_paths= []
        @document = Document.find(params[:document_id]) if !params[:document_id].blank?
        if !to.blank?
          if @notification.save
            file_names << @notification.image_file_name if !params[:email_notification][:image].blank?
            file_names << @document.file_file_name if !params[:document_id].blank?
            file_paths <<    Paperclip.io_adapters.for(@notification.image.url).read if !params[:email_notification][:image].blank?
            file_paths << (open(@document.file.url)).read if !@document.blank?
            UserMailer.email_notification(current_user.id,params,to,file_names, file_paths).deliver
          end  
        end   
      end
    end  
    redirect_to dashboard_path
  end

#Email notification create
  def message_create
  	@email_notification= EmailNotification.new(email_params)
    @email_notification.email_type="inbox"
  	if @email_notification.save
  		redirect_to thanks_message_email_notifications_path
  	else
  		redirect_to request.referrer
  	end	
  end

#after submit thankyou message appear
  def thanks_message
  end

# Email read section
  def email_read
  	@notifications=current_user.email_notifications.where(:is_read=>false)
  	if !@notifications.blank?
  		@notifications.each do |notice|
  			notice.is_read=true
  			notice.save
  		end
  	end
  end

#Display email notification
  def show
    @email=EmailNotification.find(params[:id])
  end

private
  def email_params
  	params.require(:email_notification).permit(:to, :from, :body,:user_id,:email_type,:cc,:bcc)
	end

end
