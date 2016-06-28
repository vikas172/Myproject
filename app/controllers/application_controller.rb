class ApplicationController < ActionController::Base
  # layout "new_layout"
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # before_action :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception
  before_action :team_member_permission
  before_action :active_add_on
  before_action :qb_login
  before_action :size_calculate
  #before_action :check_verfication ,except: [:check_validate,:create,:verify,:resend_code,:destroy]
  before_action :notify_message,except: [:notify]
  before_action :demo_enteries, only: [:new]
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
#Phone number verfication check
  def check_verfication
    if((!current_user.blank?) && (current_user.user_type=="admin"))
      if current_user.verified == false
        $validate_phone = false
        redirect_to phone_numbers_check_validate_path
      end
    elsif !current_user.blank?
      $validate_phone = true
      current_user.verified=true
      current_user.save!
    end 
  end
  # Give permission to Team Member
  def team_member_permission
    if !current_user.blank?
      charge_present=Charge.where("user_id =? AND account_status= ?",current_user.id,current_user.plan_type).last
      if ((current_user.created_at.to_date + 15 < Date.today) && (charge_present.blank?))
        $plan_active= false
      elsif !charge_present.blank?
        if charge_present.created_at.to_date + 30 > Date.today
          $plan_active=true
        else
          $plan_active=false
        end
      elsif current_user.created_at.to_date + 15 > Date.today
        $plan_active=true
      else
        $plan_active=false   
      end
      if current_user.user_type!="admin"
        @team_member=TeamMember.find_by_member_id(current_user.id)
      end
    end
  end

  # Add Demo entry when new Admin Sign Up
  def demo_enteries
    if !current_user.blank?
      if current_user.demo_active == true
        $check_demo =true
        redirect_to :back
      end
    end
  end
 # Calculate the Document Size
  def size_calculate
    if !current_user.blank?
      document_size = current_user.documents.collect(&:file_file_size).sum
      classified_size = current_user.classifieds.collect(&:image_file_size).compact.sum
      clients=current_user.clients.collect(&:id) if !current_user.clients.blank?
      notes= Note.where(:client_id=> clients).collect(&:id)   if !clients.blank?
      attachment_size= Attachment.where(:note_id=> notes).collect(&:image_file_size).sum if !notes.blank?
      @total_size= document_size.to_i + classified_size.to_i + attachment_size.to_i
    end
  end
  # Display the Notification Message 
  def notify_message
    if !current_user.blank?
      @client = Twilio::REST::Client.new $account_sid, $auth_token
      @message_notifications=[]
      @notifications=current_user.email_notifications.where("is_read=? AND email_type=?",false,"inbox")
      @twilio_receive=[]
      @twilio_messages = []
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
      @message=[]
      @message_views=current_user.mailbox.inbox
      @message_views.each do |mail|      
        receipts = mail.receipts_for current_user
        @message << receipts
      end
      @unread_message_show=[]
      @message.each do |receipts|
        receipts.each do |receipt|
          if receipt.is_unread?
            @unread_message_show <<  receipt.is_unread?
          end
        end
      end
      @unread_job = []
      @job = current_user.jobs.where(:status=>false)
      @job.each do|job|
        @unread_job << job
      end
    end
  end
  protected
  # Active the Add_On Status In Admin
  def active_add_on
    if !current_user.blank?
      @active_addon = current_user.add_on_statuses
    end
  end
  # Add the Parameter 
  def configure_permitted_parameters
    registration_params = [:street, :city, :state, :zipcode, :ssn, :start_date, :avatar, :email, :password, :password_confirmation, :current_password, :company_name, :full_name, :phone_number,:user_type,:plan_type,:marker_color,:mobile_number,:first_name,:last_name]
    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) { 
        |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:company_name,:full_name,:phone_number,:avatar,:email, :password, :password_confirmation,:username,:user_type,:plan_type,:marker_color,:mobile_number,:first_name,:last_name)
      end
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password) }
    end
  end

  def qb_login
    if !current_user.blank?
      session[:token] = current_user.qb_token
      session[:secret] = current_user.qb_secret
      session[:realm_id] = current_user.qb_realm_id
    end
  end
end
