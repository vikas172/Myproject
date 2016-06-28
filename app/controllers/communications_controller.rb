class CommunicationsController < ApplicationController
	protect_from_forgery :except => ["twilio_call","twilio_connect"]
	def property_note
    @property=Property.find(params[:property_id])
    @note=Note.new(:property_id=>params[:property_id],:note=>params[:note])
    @note.save
    Activity.create(:user_id=>current_user.id,:note_id=>@note.id,:property_id=>params[:property_id])
    if !params[:file].blank?
      file_upload(params[:file],@note.id)
    end
    redirect_to :back
  end

  def property_email
  	@email_notification= EmailNotification.new(email_params)
  	@email_notification.save
    Activity.create(:user_id=>current_user.id,:email_notification_id=>@email_notification.id,:property_id=>params[:property_id])
    UserMailer.property_communication(@email_notification).deliver
    redirect_to :back
  end

  def property_sms

    @twilio_client = Twilio::REST::Client.new  $account_sid,$auth_token
    twilio=@twilio_client.account.sms.messages.create({:from => "+12562724330", :to =>params[:sms][:to] , :body =>params[:sms][:body]})  rescue ""
    if !twilio.blank?
      property_sms=PropertySms.create(:from =>"+12562724330", :to =>params[:sms][:to], :body =>params[:sms][:body],:property_id=>params[:sms][:property_id],:user_id=>params[:sms][:user_id],:sms_twilio_id=>twilio.sid) rescue ""
      Activity.create(:user_id=>current_user.id,:sms_property_id=>property_sms.id,:property_id=>params[:sms][:property_id])
    end
    if !params[:other_number].blank?
      twilio_other=@twilio_client.account.sms.messages.create({:from => "+12562724330", :to =>params[:sms][:other_number] , :body =>params[:sms][:body]})  rescue ""
      property_sms_oth=PropertySms.create(:from =>"+12562724330", :other_number =>params[:sms][:other_number], :body =>params[:sms][:body],:property_id=>params[:sms][:property_id],:user_id=>params[:sms][:user_id],:sms_twilio_id=>twilio.sid) rescue " " if !twilio_other.blank?
      Activity.create(:user_id=>current_user.id,:sms_property_id=>property_sms_oth.id,:property_id=>params[:sms][:property_id])
    
    end
    redirect_to :back
  end

  def more_activity
    @property = Property.find(params[:property_id])
    if !@property.blank?
      @activities=@property.activities
    end
  end

  def edit_note_activity
    activity = Activity.find(params[:id])
    @note = Note.find(activity.note_id)
  end

  def update_note_activty
    @activity = Activity.find(params[:activity_id])
    @note= Note.find(params[:note_id])
    @note.note= params[:note]
    @note.save
  end

  def filter_activity
    @property = Property.find(params[:property_id])
    if params[:filter] == "email"
      @activities = @property.activities.where("email_notification_id is not NULL") 
    elsif params[:filter] == "sms"
      @activities = @property.activities.where("sms_property_id is not NULL") 
    elsif params[:filter] == "notes" 
      @activities = @property.activities.where("note_id is not NULL") 
    elsif params[:filter] == "all"
      @activities = @property.activities
    else
      @activities = @property.activities.where("property_call_id is not NULL")
    end
            
  end

  def call_activity

     property_call=PropertyCall.create(:from=>"+12562724758",:to=>params[:mobile],:user_id=>params[:user_id],:property_id=>params[:property_id])
     Activity.create(:property_id=>params[:property_id],:user_id=>params[:user_id],:property_call_id=>property_call.id)
  end

  def twilio_call
    
    # contact = Contact.new
    # contact.phone = params[:phone]
    # property = Property.find(params[:property_id])
    # @number = property.client.mobile_number if !property.blank?
    @number =params[:phone_number]
    # Validate contact
    if !@number.blank?
      @client = Twilio::REST::Client.new $account_sid, $auth_token
      # Connect an outbound call to the number submitted
      @call = @client.account.calls.create(:from => "+12562724758",:to => @number,:url => "#{root_url}twilio_connect") rescue " "
      if  !@call.blank?
        # Lets respond to the ajax call with some positive reinforcement
        @msg = { :message => 'Phone call incoming!', :status => 'ok' }
        render :json => @msg 
      else
        property = Property.find(params[:property_id])
        number = property.client.mobile_number if !property.blank?
        @call = @client.account.calls.create(:from => "+12562724758",:to => number,:url => "#{root_url}twilio_connect") rescue " "
        render :json => ""
      end
    else
      render :json => "Error Occur Number not validate"
    end
  end

  def twilio_connect
     response = Twilio::TwiML::Response.new do |r|
      r.Say 'If this were a real click to call implementation, you would be connected to an agent at this point.', :voice => 'alice'
    end
    render text: response.text
  end

  def communication_header
    @notification=EmailNotification.new
    @uploded_files=current_user.documents
    sms_dashboard_center
    client_user_lists
    @email_sent=current_user.email_notifications.where(:email_type=>"sent").paginate(:page => params[:page], :per_page => 5)
    @email_inbox=current_user.email_notifications.where(:email_type=>"inbox").paginate(:page => params[:page], :per_page => 5)
    @email_notifications= current_user.email_notifications
    @notifications=current_user.email_notifications.where("is_read=? AND email_type=?",false,"inbox")
    @message_views=current_user.mailbox.inbox.paginate(:page => params[:page], :per_page => 5)
    @message_sents=current_user.mailbox.sentbox.paginate(:page => params[:page], :per_page => 5)
    capability = Twilio::Util::Capability.new $account_sid, $auth_token
    params = {'user_id' => current_user.id}
    capability.allow_client_outgoing "AP1f74ef185b275ff17db9f4192cc5f8a1" ,params
    @token = capability.generate
  end

  # def email_user_notifications
   
  # end
  def client_user_lists
    if current_user.user_type=="admin"
      @team=current_user.team_members.where('member_id IS NOT NULL')
      @user_list=@team
      @clients_list=current_user.clients
    else
      @team=[]
      @user1=[]
      @user = @team_member.user
      @user_team= @team_member.user.team_members.where("member_id!=?",current_user.id)
      @team <<  @user
      if !@user_team.blank?
        @user_team.each do |team|
          @user1 << User.find(team.member_id)
        end
        @team << @user1
      end  
      @team = @team.flatten
      @user_list=@team
    end
  end

  def sms_dashboard_center

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
      @twilio_message.each  {|p| @twilio_messages << p if p.from == @number }
      @twilio_message.each  {|p| @twilio_receive << p if p.to == @number }
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

  private
  	def file_upload(params,note)
      params.each do |file|
        @attachment=Attachment.new(:image=>file,:note_id=>note)
        @attachment.save
      end
    end
    def email_params
  		params.require(:email_notification).permit(:to, :from, :body,:user_id,:email_type,:cc,:bcc,:subject)
		end
    def sms_params
      params.require(:sms).permit(:to,:from,:body,:property_id,:user_id)
    end
end