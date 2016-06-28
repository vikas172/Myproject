class DocumentsController < ApplicationController
  include DocumentsHelper

#Check document memory 
	def create
    if current_user.plan_type=="solo"
      if @total_size < Document::STORAGE[0]
        store_image(params)
      else
        redirect_to dashboard_path, notice: 'Please upgrade your account for more documents.'
      end
    elsif  current_user.plan_type=="team"  
      if @total_size < Document::STORAGE[1] 
        store_image(params)
      else
        redirect_to dashboard_path, notice: 'Please upgrade your account for more documents.'
      end
    else 
      if @total_size < Document::STORAGE[2]
        store_image(params)
      else
        redirect_to dashboard_path, notice: 'Please upgrade your account for more documents.'
      end
    end  
  end

#Create or store document
  def store_image(params)
    if !params[:document].blank?
      if current_user.user_type == "admin"
        current_user.documents.create(:file=>params[:document][:file],:file_type=>params[:file_type])
      else
        user_id= @team_member.user.id
        Document.create(:user_id=>user_id,:file=>params[:document][:file],:file_type=>params[:file_type])
      end
    end
    redirect_to dashboard_path, notice: 'Document add successfully'
  end  

#Download document
  def download
  	@document = Document.find(params[:id])
  	require 'open-uri'
		url = @document.file.url
		data = open(url).read
		send_data data, :disposition => 'attachment', :filename=>"#{@document.file_file_name}" 
  end

#Destory document
  def destroy
  	@document = Document.find(params[:id])
    @document.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_path, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

#Delete user and its dependency
  def delete_account
    @general_info=current_user.general_info
    if !@general_info.blank?
      if !@general_info.service_number.blank?
        client = Twilio::REST::Client.new ENV["account_sid"],ENV["auth_token"]
        client.account.incoming_phone_numbers.list.each do |num|
          @general_info.service_number ==  num.phone_number
          num.delete
        end
      end
    end 
    dependency_all(current_user)
    current_user.destroy   
    redirect_to root_url
  end

#display document box
  def document_box
    @document=Document.new
    @documents_hr = current_user.documents.where(:file_type=>"hr_document")
    @documents = current_user.documents.where(:file_type=>"team_document")
    @documents_contract = current_user.documents.where(:file_type=>"contract_document")
    @documents_company = current_user.documents.where(:file_type=>"company_document")
  end

#communication view display sent, inbox mail and email
  def communication
    @notification=EmailNotification.new
    sms_dashboard_center
    @email_sent=current_user.email_notifications.where(:email_type=>"sent").paginate(:page => params[:page], :per_page => 5)
    @email_inbox=current_user.email_notifications.where(:email_type=>"inbox").paginate(:page => params[:page], :per_page => 5)
    @email_notifications= current_user.email_notifications
    @notifications=current_user.email_notifications.where("is_read=? AND email_type=?",false,"inbox")
    @message_views=current_user.mailbox.inbox.paginate(:page => params[:page], :per_page => 5)
    @message_sents=current_user.mailbox.sentbox.paginate(:page => params[:page], :per_page => 5)
    @uploded_files=current_user.documents
    client_user_lists
    capability = Twilio::Util::Capability.new $account_sid, $auth_token
    capability.allow_client_outgoing "AP1f74ef185b275ff17db9f4192cc5f8a1"
    @token = capability.generate
  end

#sms dashboard center contain twilio message 
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

#display users list admin and its team member
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

  def document_setting
  end

  def document_check
    current_user.company_document = params[:company_document]
    current_user.hr_document = params[:hr_document]
    current_user.contract_document = params[:contract_document]
    current_user.save
    redirect_to :back
  end

end
