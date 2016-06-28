class PropertiesController < ApplicationController
  include ClientsHelper
  include HomeHelper
  include JobsHelper
  require 'open_weather'
  load_and_authorize_resource except:[:create]
  # before_action :set_property, only: [:show, :edit, :destroy,:update_property]
  before_action :authenticate_user!
  # GET /properties
  # GET /properties.json
  def index
    @clients = Client.where(:user_id=>current_user.id)
    if current_user.user_type=="user"
      user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
      @clients = Client.where(:user_id=>user_type_id)
      @properties = Property.where(:user_id=>user_type_id)
    else
      @clients = Client.where(:user_id=>current_user.id)
      @properties = Property.where(:user_id=>current_user.id)
    end
    @zipcodes= @properties.collect {|p| [ p.zipcode, p.id ]}.uniq{|p| p[0]}
  end

  # GET /properties/1
  # GET /properties/1.json
  def show
    capability = Twilio::Util::Capability.new $account_sid, $auth_token
    params = {'user_id' => current_user.id,'property_id'=>@property.id}
    capability.allow_client_outgoing "AP48ec28002bfe7125415faae00462f296" ,params
    @token = capability.generate
    @notes= @property.notes
    @service_builder = ServicePlan.where(:user_id=>current_user.id ,:property_id=>nil)
    @plan_builder = ServicePlan.find(@property.server_plan_id) rescue ""
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Properties")
    @custom_field_data=@property.custom_field if !@property.custom_field.blank?
    quote_jobs(@property)
    @check_used =current_user.chemical_items.where(:property_id=>nil).last
    @service_plan = current_user.service_plans.where(:property_id=>nil)
    @property_service = ServicePlan.find(@property.server_plan_id) if !@property.server_plan_id.blank?
  end

#Call pool show method 
  def quote_jobs(property)
    @quotes_all=[]
    @jobs_all=[]   
    @client_id=property.client.id
    @client=Client.find(@client_id) 
    @properties=@client.properties
    if !@properties.blank?
      @properties.each do |property|
        @quotes_all<<property.quotes
        @jobs_all<<property.jobs    
      end
    end
    @quotes_all=@quotes_all.flatten
    @jobs_all=@jobs_all.flatten
    method_call(@jobs_all,@quotes_all,property)
  end

#call quote jobs method to get basic task and event
  def method_call(jobs_all,quotes_all,property)
    @active_jobs=active_job_display(jobs_all)
    @active_quotes=active_quote_display(quotes_all)
    basic_task_view(property)
    event_view(property)
  end

#property events view
  def event_view(property)
    @property=property
    @events=@property.events
    @complete_event= @events.where('start_date < ?', Date.today) 
    @upcoming_event= @events.where('start_date > ?', Date.today)
    @today_event= @events.where('start_date = ?', Date.today)
  end

#basic task for property
  def basic_task_view(property)
    @property=property
    @basic_task_display=@property.basic_tasks
    @complete_basic_task = @basic_task_display.where(is_completed: true)
    @basic_task_unschedule= @basic_task_display.where(:is_completed=> false,:start_at_date=>nil)
  end

  # GET /properties/new
  def new
    @market_sources = MarketSource.where(:user_id=>current_user.id)
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Properties")
    @property = Property.new
    if !params[:client_id].nil?
      @client=Client.find(params[:client_id])
    end
    @quote=Quote.find(params[:quote_id]) unless params[:quote_id].nil?
    @property_value=Property.find(params[:prop_id]) unless params[:prop_id].nil?
  end

  # GET /properties/1/edit
  def edit
    @market_sources = MarketSource.where(:user_id=>current_user.id)
    # @client = Client.find(params[:client_id])
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Properties")
    @custom_field_data=@property.custom_field if !@property.custom_field.blank?
  end

  # POST /properties
  # POST /properties.json
  def create
    @geocode=[]
    @property = Property.new(property_params)
    @property.client_id=params[:client_id] 
    if current_user.user_type=="user"
      user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
      @property.user_id = user_type_id
    else
      @property.user_id=current_user.id
    end
    if params[:property][:pool_activity] == "lead"
      @property.lead = true
    end
    @property.custom_field=params[:custom_field]
    @location=gecode_find(@property, @geocode)
    @property.latitude=@location[0] unless @location.blank?
    @property.longitude=@location[1] unless @location.blank?
    respond_to do |format|
      if @property.save
        pool_photos(params,@property)
        property_after_create_url(params,@property,format)
      else
        format.html { render :new }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

#Pool photos created
  def pool_photos(params,property)
    if !params[:photos].blank?
      params[:photos].each do |photo|
        property.pools.create(:photo=>photo)
      end
    end
  end

  # PATCH/PUT /properties/1
  # PATCH/PUT /properties/1.json
  def update_property
    respond_to do |format|
      @geocode=[]
      if @property.update(property_params)
        @property.custom_field=params[:custom_field] 
        @location=gecode_find(@property, @geocode)
        @property.latitude=@location[0] unless @location.blank?
        @property.longitude=@location[1] unless @location.blank?
        @property.save 
        pool_photos(params,@property) 
        format.html { redirect_to property_path, notice: 'Property was successfully updated.' }
        format.json { render :show, status: :ok, location: @property }
      else
        format.html { render :edit }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /properties/1
  # DELETE /properties/1.json
  def destroy
    @property.destroy
    respond_to do |format|
      format.html { redirect_to properties_url, notice: 'Property was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

#Search clients in list
  def search_client_property
    params[:q]=params[:q].gsub(/\s+/, "")
    @clients=current_user.clients.where('LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(company_name) LIKE ?', "#{params[:q].downcase}%","#{params[:q].downcase}%","#{params[:q].downcase}%")
  end

#if gecode is not there so manually user set the postion
  def manually_geocode
    @property=Property.find(params[:id])
    @job = params[:job]
    @client= params[:client]
  end

#property map location update
  def location_update
    @property=Property.find(params[:property_id])
    @property.latitude=params[:property]["latitude"]
    @property.longitude=params[:property]["longitude"]
    @property.save
    if !params[:job_id].blank?
      redirect_to job_path(params[:job_id])
    elsif params[:client_id].blank?
      redirect_to property_path(:id=>@property.id,client_id: @property.client.id)
    else
      redirect_to "/clients/#{params[:client_id]}?value=client_show"
    end
  end

#property basic task
  def property_basic_task
    @basic_action="new"
    @basic = current_user.basic_tasks.new 
    @property=Property.find(params[:property_id])
    if current_user.user_type == "admin"
      @members = current_user.team_members
    else
      @members = TeamMember.where(user_id: @team_member.user_id)
    end
  end

#property events
  def property_event
    @event_action="new"
    @event = current_user.events.new
    @start_event=Date.today
    @end_event=Date.today
    @property=Property.find(params[:property_id])
  end

#Basic task completed
  def basic_task_complete
    @basic_task=BasicTask.find(params[:basic_id])
    if params[:is_complete]== "false"
       @basic_task.is_completed = false
    else  
      @basic_task.is_completed = true
      @basic_task.complete_by = params[:complete_by]
      @basic_task.completed_date = Date.today.strftime("%Y/%m/%d")
    end
    @basic_task.save
    display_basic_result(params)
  end

#basic task result display
  def display_basic_result(params)
    @property=Property.find(params[:property_id])
    @basic_task_display=@property.basic_tasks
    @complete_basic_task = @basic_task_display.where(is_completed: true)
    @basic_task_unschedule= @basic_task_display.where(:is_completed=> false,:start_at_date=>nil)
    @events=@property.events
    @complete_event= @events.where('start_date < ?', Date.today) 
    @upcoming_event= @events.where('start_date > ?', Date.today)
    @today_event= @events.where('start_date = ?', Date.today)
  end

#property basic task created
  def property_task_create
    if params[:action_type]=="new"
      @basic_task = current_user.basic_tasks.create(basic_task_params)
      if params[:basic_task][:assigned_to].blank?
        @basic_task.assigned_to= (current_user.id).to_s.split()
      else
        @basic_task.assigned_to=params[:basic_task][:assigned_to]
      end
      @basic_task.property_id=params[:property_id]
      @basic_task.save
    else
      @basic=BasicTask.find(params[:basic_id])
      @basic=@basic.update(basic_task_params)
    end  
    redirect_to request.referer
  end

#property events created
  def property_event_create
    if params[:action_type]=="new"
      @event = current_user.events.new(event_params)
      @event.property_id=params[:property_id]
      @event.save
    else
      @event=Event.find(params[:event_id])
      @event.update(event_params)
    end  
    redirect_to request.referer
  end

#destory property event and basic task
  def delete_event_task
    if params[:event_task]=="event"
      @event=Event.find(params[:event_id])
      @event.delete
    else
      @basic=BasicTask.find(params[:basic_id])
      @basic.delete
    end  
    redirect_to request.referer
  end

#show event and basic task
  def show_event_task
    if params[:type]=="event"
      @event= Event.find(params[:type_id])
    else
      @basic=BasicTask.find(params[:type_id])
    end  
  end

#edit event and basic task 
  def edit_event_task
    if params[:basic_id].blank?
      @event_action="update"
      @event=Event.find(params[:event_id])
      @start_event=@event.start_date
      @end_event=@event.end_date
      @property=@event.property
    else
      @basic_action="update"
      @basic=BasicTask.find(params[:basic_id])
      @property=@basic.property
    end  
  end

#select plan builder on the service plan under the property
  def property_service_plan
    @property =Property.find(params[:property_id])
    @service = ServicePlan.find_by_property_id(params[:property_id])
    @service.destroy if !@service.blank?
    @property.server_plan_id= params[:service_plan] if !params[:service_plan].blank?
    @property.save
    redirect_to :back
  end

#pool update active 
  def pool_update_active
    @property =Property.find(params[:property_id])
    @property.pool_activity = params[:pool_activity] if !params[:pool_activity].nil?
    @property.pool_notes = params[:pool_notes] if !params[:pool_notes].nil?
    @property.save rescue ""
    if ((@property.pool_activity != "lead" )&& (@property.pool_activity !="followup"))
      @property.converted_date = Date.today
      @property.save
    end  
    redirect_to :back
  end

#display lead clients
  def convert_client
    @clients = current_user.clients.where("personal_email!= ?","lead@mailinator.com")
  end

#Convert lead to main pool
  def converted
    @property = Property.find(params[:property_id])
    if params[:client_id].blank?
      client= Client.new(client_params)
      client.user_id = current_user.id
      client.mobile_number= params[:initial_phone]+params[:client][:mobile_number]
      if client.save
        @property.client_id = client.id
        @property.pool_activity = "active"
        @property.lead = false
        @property.save
      end
    else
      @property.client_id = params[:client_id]
      @property.pool_activity = "active"
      @property.lead = false
      @property.save
    end
    redirect_to property_path(:id=>@property.id)
  end

#display the list of lead templates
  def lead_message
    @templates = current_user.lead_templates.where(:pool_activity_type=>"lead_message")
  end

#generate lead message pdf
  def lead_message_pdf
    @property=[]
    if !params[:filters].blank?
      if !params[:filters].keys.blank?
        params[:filters].keys.each do |property_id|
          @property << Property.find(property_id) if (property_id.to_i != 0)
        end
      end
    end
    if params[:save_as_templates].present?
      LeadTemplate.create(:user_id=>current_user.id,:pool_activity_type=>params[:pool_activity_type],:content=>params[:content].gsub("\r\n\r\n","").gsub("\r\n","")) if !params[:content].blank?
    end
    user = current_user
    @clients = current_user.clients
    html = render_to_string(:layout => false )
    kit = PDFKit.new(html, :page_size => 'Letter')
    send_data(kit.to_pdf, :filename => "lead.pdf", :type => 'application/pdf')
    thepdf= kit.to_file("#{Rails.root}/tmp/kit.pdf")
    UserMailer.email_to_pdf(user,thepdf).deliver
  end

#Create property tag
  def property_tag
    @property=Property.find(params[:property_id])
    @property.tag_list.add(params[:pool_tag])
    @property.save
  end

#delete property tag
   def tag_delete
    @property=Property.find(params[:property_id])
    @property.tag_list.remove(params[:name])
    @property.save
   end

#display lead templates content
   def templates_display
    @templates=LeadTemplate.find(params[:template_id]).content
   end

# display lead templates 
   def email_message
    @templates = current_user.lead_templates.where(:pool_activity_type=>"pool_email")
   end

# messge and email send to the pool
   def message_email_sent
    if params[:save_as_templates].present?
      LeadTemplate.create(:user_id=>current_user.id,:pool_activity_type=>params[:pool_activity_type],:content=>params[:message].gsub("\r\n\r\n","").gsub("\r\n","")) if !params[:message].blank?
    end
    if !params[:filters].blank?
      if !params[:filters].keys.blank?
        params[:filters].keys.each do |property_id|
          @property = Property.find(property_id) if (property_id.to_i != 0)
          message= get_marketing_content(params[:message],@property).html_safe
          UserMailer.pool_message_filter(@property,message).deliver if (property_id.to_i != 0)
        end
      end
    end
    redirect_to :back
   end

   def lead_mailer
   end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id]) rescue ""
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def property_params
      params.require(:property).permit(:street, :street2, :city, :state, :zipcode, :country,:pool_name,:pool_type,:pool_volume,:pool_volume2,:pool_activity,:pool_gate_code,:pool_lifeguards,:pool_notes,:market_source,:server_plan_id,:lead,:pool_source,:pool_tag,:converted_date,:pool_subject,:pool_comment)
    end

    def basic_task_params
      params.require(:basic_task).permit(:title, :description,:start_at_date,:end_at_date, :start_at_time, :end_at_time, :all_day, :repeat, :is_completed, :complete_by, :completed_date, :assigned_to)
    end

    def event_params
      params.require(:event).permit(:title, :description,:start_date,:end_date, :start_time, :end_time, :all_day)
    end
     def client_params
      params.require(:client).permit(:initial, :first_name, :last_name, :company_name, :primary_company, :street1, :street2, :city, :state, :zip_code, :country, :personal_email, :mobile_number ,:preference_notification,:phone_number,:email)
    end
end
