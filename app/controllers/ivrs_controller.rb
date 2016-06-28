class IvrsController < ApplicationController
  before_action :set_ivr, only: [:show, :edit, :update, :destroy, :release, :templates, :calls, :apply_template , :analytics , :filters]
  protect_from_forgery :except => :twiml
  skip_before_filter :require_login, :only => [:twiml, :check_email, :create_beta, :handle_recording, :twiml_repeat_menu, :create_feedback, :sms_callback]

  # GET /ivrs
  # GET /ivrs.json
  def index
    #only demo attendants
    #@ivrs = Ivr.where(:is_sub_menu => nil , :is_template => nil , :free => true , :user_id => nil)
    #
    #if params[:account_update]
    #  @account_update = params[:account_update]
    #end
    
    @ivr = Ivr.where(:uuid => "42827ca66fd341bdbc180b4f6e7f1b74").first
    redirect_to edit_ivr_path(@ivr.uuid)
  end

  # GET /ivrs/1
  # GET /ivrs/1.json
  def show
  end

  # GET /ivrs/new
  def new
    @ivr = Ivr.new

    #For announcement
    key = @ivr.keys.build(:digit => "10", :action_type_id => ActionType.find_by_code("PT").id)
    key.key_actions.build(:say => "")

    #For other keys
    10.times do |i|
      key = @ivr.keys.build(:digit => i.to_s, :action_type_id => ActionType.find_by_code("NA").id)
      key.key_actions.build
    end
  end

  # GET /ivrs/1/edit
  def edit

    logger.debug "=========================="
    logger.debug session[:uid]
    logger.debug "=========================="

    #track reservation for demo attendants
    if @ivr.free
      Reservation.create(:user_id => session[:user_id], :ivr_id => @ivr.id)
      @ivr.update :user_email => session[:uid]
    end

    #click to call
    
    if @ivr and @ivr.application_id
      logger.debug "=================click to call token=================="
      # set up
      capability = Twilio::Util::Capability.new $account_sid, $auth_token

      # allow outgoing calls to an application
      # demo app
      capability.allow_client_outgoing @ivr.application_id

      @token = capability.generate
    end
  end

  def release
    @ivr.release_ivr
    @ivrs = Ivr.where(:is_sub_menu => nil)
    redirect_to edit_ivr_path(@ivr.uuid)
  end


  def templates
    @templates = Ivr.where(:is_template => true)
  end

  def apply_template
    template = Ivr.where(:id => params[:template_id], :is_template => true).first
    result = "Recipe applied for the Auto Attendant."
    if template
      @ivr.use_recipe_ivr(params[:template_id])
    else
      result = "Not able to apply the recipe. Please try again later"
    end

    respond_to do |format|
      format.html { redirect_to edit_ivr_path(@ivr.uuid), notice: result }
    end
  end

  #call logs
  def calls
    @ivr = Ivr.find_by_uuid(params[:id])
    @calls = @ivr.calls.paginate(:page => params[:page], :per_page => 10)

    # @call = $twilio_client.calls.create(
    #    from: '+12018993959',
    #    to: '+918109078749',
    #    url: 'http://4fb4bd5f.ngrok.com/ivrs/AP5951af88fb23bff0faeee08b34a100de/twiml/repeat_menu/1'
    # )
  end

  def analytics

    @keys= KeyDescription.where(:user_id=>current_user.id).order('id asc')
    if @keys.blank?
      @keys= KeyDescription.where(:user_id=>nil)
    end
    @calls = Transaction.where.not(:key_press => nil).paginate(:page => params[:page], :per_page => 10)
    @transaction = Transaction.new(:start_date => Transaction.first.created_at.strftime("%m/%d/%Y") , :end_date => Time.now.strftime("%m/%d/%Y")) rescue ""
  end

  def filters
    
    s = DateTime.strptime(params[:transaction][:start_date], "%Y-%m-%d")
    e = DateTime.strptime(params[:transaction][:end_date], "%Y-%m-%d")
    @calls = Transaction.where("created_at > ? AND created_at < ?" , s , e).paginate(:page => params[:page], :per_page => 10)
    @transaction = Transaction.new(:start_date => params[:transaction][:start_date] , :end_date => params[:transaction][:end_date])
    render "ivrs/analytics"
  end

  def handle_recording

    call = Call.find_by_call_sid(params[:CallSid])
    attendant = Ivr.find_by_uuid(params[:id])

    t = Transaction.create(:call_id => call.id, :key_press => params[:Digits], :twilio_location => params[:RecordingUrl])

    #download from twilio to local machine
    attendant.download_file(params[:RecordingUrl], t)
    file_destination = "#{$recordings_destination}/#{t.id}"
    t.update(:recording => File.open(file_destination))

    if attendant.current_user
      UserMailer.delay.recording_notification(User.find_by_login(attendant.current_user), t, attendant)
    end

    json = {"Say" => "Recording has been received. Thank you"}

    xml_string = Gyoku.xml({"Response" =>
                                {
                                    :content! => json,
                                }})
    doc = Nokogiri::XML(xml_string)
    logger.debug "====================TWIML===================="
    logger.debug doc.human
    logger.debug "====================END OF TWIML===================="
    @twiml = doc


    respond_to do |format|
      format.html {
        render :layout => false, :action => "twiml" #, type: "application/xml"
      }
      format.xml {
        render :layout => false, :partial => "twiml" #, type: "application/xml"
      }
    end
  end

  def twiml_repeat_menu

    #submenu or mainmenu
    if params[:sub_menu_id].blank?
      attendant = Ivr.find_by_uuid(params[:id])
    else
      attendant = Ivr.find_by_id(params[:sub_menu_id])
    end

    call = Call.find_by_call_sid(params[:CallSid])
    if call.blank?
      call = Call.create(:call_sid => params[:CallSid], :ivr_id => attendant.id, :caller_state => params[:CallerState], :caller_city => params[:FromCity], :caller => params[:From], :caller_number => params[:From])
    end
    Transaction.create(:call_id => call.id, :key_press => params[:Digits], :recording => params[:RecordingUrl])


    @twiml = attendant.generate_twiml_menu

    respond_to do |format|
      format.html {
        render :layout => false, :action => "twiml" #, type: "application/xml"
      }
      format.xml {
        render :layout => false, :partial => "twiml" #, type: "application/xml"
      }
    end

  end

  def twiml

    #submenu or mainmenu
    if params[:sub_menu_id].blank?
      attendant = Ivr.find_by_uuid(params[:id].downcase)
    else
      attendant = Ivr.find_by_uuid(params[:sub_menu_id])
    end

    call = Call.find_by_call_sid(params[:CallSid])
    skip_transaction_creation = nil
    #5 calls grace

    if call.blank? and (attendant.free or attendant.call_balance > 0)
      call = Call.create(:call_sid => params[:CallSid], :ivr_id => attendant.id, :caller_state => params[:CallerState], :caller_city => params[:FromCity], :caller => params[:From],:caller_number=>params[:Form])

      #reduce call balance by 1
      attendant.update(:call_balance => (attendant.call_balance - 1)) rescue ""

    elsif call.blank? and attendant.call_balance <= 0
      #please recharge soon IVR message
      @twiml = attendant.recharge_soon_ivr
      skip_transaction_creation = true
    end

    if skip_transaction_creation.blank? and call
      Transaction.create(:call_id => call.id, :key_press => params[:Digits], :recording => params[:RecordingUrl])
    end


    #params[:pressed] check is for announcements check
    if !attendant.blank? and params[:Digits].blank? and @twiml.blank?
      @twiml = attendant.generate_twiml_menu
      #key pressed
    elsif !attendant.blank? and @twiml.blank?
      if call
        @twiml = attendant.generate_twiml_keypress(params[:Digits], nil)
      else
        @twiml = attendant.generate_twiml_keypress(params[:Digits])
      end
    end

    respond_to do |format|
      format.html {
        render :layout => false, :action => "twiml" #, type: "application/xml"
      }
      format.xml {
        render :layout => false, :partial => "twiml" #, type: "application/xml"
      }
    end
  end


  def sms_callback

    attendant = Ivr.find_by_uuid(params[:id])

    if params[:SmsStatus] == "sent"
      json = {"Say" => "A Text message was sent you. Thank you"}
    else
      json = {"Say" => "Text message failed to be delivered to you"}
    end

    xml_string = Gyoku.xml({"Response" =>
                                {
                                    :content! => json,
                                }})
    doc = Nokogiri::XML(xml_string)
    logger.debug "====================TWIML===================="
    logger.debug doc.human
    logger.debug "====================END OF TWIML===================="
    @twiml = doc


    respond_to do |format|
      format.html {
        render :layout => false, :action => "twiml" #, type: "application/xml"
      }
      format.xml {
        render :layout => false, :partial => "twiml" #, type: "application/xml"
      }
    end
  end

  # POST /ivrs
  # POST /ivrs.json
  def create
    @ivr = Ivr.new(ivr_params)
    #@ivr.save

    respond_to do |format|
      if @ivr.save
        format.html { redirect_to @ivr, notice: 'Ivr was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ivr }
      else
        format.html { render action: 'new' }
        format.json { render json: @ivr.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ivrs/1
  # PATCH/PUT /ivrs/1.json
  def update
    respond_to do |format|
      if @ivr.update(ivr_params)
        format.html { redirect_to edit_ivr_path(@ivr.uuid), notice: 'Auto Attendant was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ivr.errors, status: :unprocessable_entity }
      end
    end
  end

  def check_email

    if params[:email_id] and params[:email_id].email?
      if !User.all.pluck(:login).include? params[:email_id]
        @error_notice = nil
      else
        #Email id exists validation
        @error_notice = "There is already an account with this email address"
      end
    else
      #email validation
      @error_notice = "Please enter a valid email address"
    end

  end

  def create_beta
    @beta = Beta.new(beta_params)

    respond_to do |format|
      if @beta.save
        format.html { redirect_to root_path, notice: 'Signed up successfully' }
      end
    end
  end

  def create_feedback
    @feedback = Feedback.new(feedback_params)

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to (feedback_params[:return_url].blank? ? ivrs_path : feedback_params[:return_url]), notice: 'Thanks for your feedback' }
        format.js { render "create_feedback" }
      end
    end

  end

  def add_sub_menu

    @key_action_wrapper_id = params[:key]
    @ivr = Ivr.new

    #For announcement
    key = @ivr.keys.build(:digit => "10", :action_type_id => ActionType.find_by_code("PT").id)
    key.key_actions.build(:say => "")

    #For other keys
    10.times do |i|
      if (i.to_s == params[:key])
        key = @ivr.keys.build(:digit => i.to_s, :action_type_id => ActionType.find_by_code("TSB").id)
        key_action = key.key_actions.build
        @menu = key_action.sub_menus.build
        @menu.is_sub_menu = true

        #For announcement
        menu_keys = @menu.keys.build(:digit => "10", :action_type_id => ActionType.find_by_code("PT").id)
        menu_keys.key_actions.build(:say => "")

        10.times do |j|
          menu_keys = @menu.keys.build(:digit => j.to_s, :action_type_id => ActionType.find_by_code("NA").id)
          menu_keys.key_actions.build
        end
        next
      end
      key = @ivr.keys.build(:digit => i.to_s, :action_type_id => ActionType.find_by_code("NA").id)
      key.key_actions.build
    end


  end

  # DELETE /ivrs/1
  # DELETE /ivrs/1.json
  def destroy
    @ivr.destroy
    respond_to do |format|
      format.html { redirect_to ivrs_url }
      format.json { head :no_content }
    end
  end


  def key_description
    @keys=KeyDescription.where(:user_id=>current_user.id)
    if !@keys.blank?
      @key= KeyDescription.find(params[:id])
      @key.description= params[:description]
      @key.save  
    else
      @keys=KeyDescription.where(:user_id=>nil)
      @keys.each do |key|
        @key= KeyDescription.new
        if key.id  == params[:id].to_i
          @key.description= params[:description]
        else
          @key.description= key.description
        end
        @key.user_id=current_user.id
        @key.key_number= key.key_number
        @key.save
      end
    end
    redirect_to request.referrer
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ivr
    #First search by uuid
    
    @ivr = Ivr.find_by_uuid(params[:id])
    @ivr ||= Ivr.find_by_uuid(params[:uuid])
    @ivr ||= Ivr.find(params[:id]) rescue ""
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ivr_params
    #params.require(:ivr).permit(:phone, :status, :user_id , keys_attributes: [:id , :digit , :action_type_id ,  key_actions_attributes: [:id , :play , :say , :dial, :record  ]])
    ActionController::Parameters.permit_all_parameters = true
    params.require(:ivr)
  end

  def beta_params
    params.require(:beta).permit(:name, :email, :feedback)
  end

  def feedback_params
    params.require(:feedback).permit(:comment, :user_id, :like, :scheduling, :submenu, :api, :analytics, :name, :email, :phone, :return_url)
  end


end
