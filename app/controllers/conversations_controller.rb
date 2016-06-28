class ConversationsController < ApplicationController
  before_filter :authenticate_user!
  helper_method :mailbox, :conversation

  def create
    
    recipient_emails = conversation_params(:recipients)
    recipient_emails = User.where(:id=>params[:conversation][:recipients]).collect(&:email)
    recipients = User.where(email: recipient_emails).all
    conversation = current_user.
      send_message(recipients, *conversation_params(:body, :subject)).conversation
    redirect_to dashboard_path
    user_name = params[:conversation]["recipients"]
    user_name.each do |name|
      Pusher['private-'+name].trigger('new_message', {:from => current_user.first_name, :subject => params[:conversation]["subject"]})
    end
  end

  def reply
    current_user.reply_to_conversation(conversation, *message_params(:body, :subject))
    redirect_to dashboard_path
  end

  def trash
    conversation.move_to_trash(current_user)
    redirect_to :conversations
  end

  def untrash
    conversation.untrash(current_user)
    redirect_to :conversations
  end

  def index
    @all_inbox_message=current_user.mailbox.inbox
  end

  def show
    @message_type=params[:data]
    @conversation=mailbox.conversations.find(params[:id])
    @conversation.mark_as_read(current_user)
  end

  def new
    if current_user.user_type=="admin"
      @users=current_user.team_members.collect(&:email)
    else
      @users=[]
      @user=User.find(@team_member.user_id)
      @admin_tm=@user.team_members.where("member_id != ?",current_user.id).collect(&:email)
      @users << @user.email
      @users << @admin_tm
      @users=@users.flatten
    end
  end

  def notify
   
    if current_user
       @mail = current_user.mailbox.inbox  
       @unread_message=[]
       @unread_job = []
       @message =[]
       @mail.each do |mail|      
          receipts = mail.receipts_for current_user
          @message << receipts
       end
       @message.each do |receipts|
          receipts.each do |receipt|
            if receipt.is_unread?
              @unread_message <<  receipt.is_unread?
            end
          end
       end
      # @job = current_user.jobs.where(:status=>false)
      #  @job.each do|job|
      #     @unread_job << job
      #  end
      @job = current_user.jobs
      @job.each do|job|
        if job.status == false
          @unread_job << job
        end
    end
    end   
      #twilio_notification
  end

  def display_notify
    @message_display=Mailboxer::Message.find_by_conversation_id(params[:value_notice]) rescue " "

  end

  def update_notify
    # @mail = current_user.mailbox.inbox  
    # @mail.each do |mail|
    #   @unread_notify = mail.receipts_for current_user
    # end
     
    message_notification
    @unread_job = []
    @jobs = []
    @job = current_user.jobs.where(:status=>false)
    @job.each do|job|
      @jobs << job
      @unread_job << job
    end
    @jobs.each do |job|
      job.status = true
      job.save
    end
    twilio_notification
  end

  def twilio_notification
    @client = Twilio::REST::Client.new $account_sid, $auth_token
    @receive_messages=[]
    @sent_message=[]
    @deliever_messsage=[]
    @message_notifications=[]
    @twilio_messages=[]
    @twilio_receive=[]
    @twilio_message= @client.account.sms.messages.list rescue "" 
    @number=current_user.general_info.service_number  if !current_user.general_info.blank?
    if !@twilio_message.blank? && !@number.blank?
      @twilio_message.each do |p|
        if p.from == @number
          @twilio_messages << p
        end
      end
       
      # @twilio_message.each  {|p| @twilio_messages << p if p.from == @number }
      # @twilio_message.each  {|p| @twilio_receive << p if p.to == @number }
    end
    if !current_user.message_notify.blank?
      @twilio_receive.each  {|p| @message_notifications<< p if ((p.status=="received" )&& (p.date_created > current_user.message_notify) && (p.date_created.to_date > current_user.message_notify.to_date))}
    else
      @twilio_receive.each  {|p| @message_notifications<< p if p.status=="received" }
    end
    if !@twilio_messages.blank?
      @twilio_receive.each  {|p| @receive_messages<< p if p.status=="received"}
      @twilio_messages.each  {|p| @deliever_messsage << p if p.status=="delivered"}
      @twilio_messages.each  {|p| @sent_message << p if p.status=="sent"}
    end
  end

  def message_notification
    @mail = current_user.mailbox.inbox  
    @unread_notify =[]
    @message = []
    @mail.each do |mail| 
      receipts = mail.receipts_for current_user
      @message << receipts     
      @unread_notify << mail
    end

    @message.each do |message|
      message.first.is_read = true
      message.first.save
    end
  end

  private

  def mailbox
    @mailbox ||= current_user.mailbox
  end

  def conversation
    @conversation ||= mailbox.conversations.find(params[:id])
  end

  def conversation_params(*keys)
    fetch_params(:conversation, *keys)
  end

  def message_params(*keys)
    fetch_params(:message, *keys)
  end

  def fetch_params(key, *subkeys)
    params[key].instance_eval do
      case subkeys.size
      when 0 then self
      when 1 then self[subkeys.first]
      else subkeys.map{|k| self[k] }
      end
    end
  end
end
