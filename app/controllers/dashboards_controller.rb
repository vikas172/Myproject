class DashboardsController < ApplicationController
  before_action :authenticate_user!
  require 'barometer'
  require 'open_weather'
  include JobsHelper

	def dashboard
    #if current_user.verified == true
      if session[:set_job_url]== nil
        @document=Document.new
        today_job_quote_invoice
        get_job_months @jobs
        @invoices=Invoice.where(:user_id=>current_user.id, :mark_sent=>true,:invoice_bad_debt=>false,:invoice_paid=>false)
      else
        @url= session[:set_job_url]
        session[:set_job_url]=nil
        redirect_to @url
      end  
      @uploded_files=current_user.documents
      generate_twilio_token
      recent_schedule_task
      # @message_views=current_user.mailbox.inbox.paginate(:page => params[:page], :per_page => 5)
      # @message_sents=current_user.mailbox.sentbox.paginate(:page => params[:page], :per_page => 5)
      @convert_job = Job.all.map{|x| x.quote_id if x.user_id == current_user.id}.compact
      @covert_job_total = eval(QuoteWork.all.map{|x| x.total if @convert_job.include? x.quote_id}.compact.flatten.join("+"))
    # else
    #   redirect_to  phone_numbers_check_validate_path
    # end  
  end
  # Display Today Task
  def recent_schedule_task
    if current_user.user_type== "admin"  
      @job=Job.where(:user_id=>current_user.id).collect(&:id)
    else
      user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
      @job= Job.where(:user_id=>user_type_id).collect(&:id)
    end
    @today_schedule=VisitSchedule.where(:job_id=> @job,:start_date=>Date.today,:job_complete=>false)
    @today_event=current_user.events.where(:start_date=>Date.today)
    @today_basic=current_user.basic_tasks.where("start_at_date <=? AND end_at_date >=? AND is_completed=?",Date.today,Date.today,false)
    @address= []
    @user=[]
    if !@today_schedule.blank?
      @today_schedule.each_with_index do |visit_schedule,index|
        @crew = visit_schedule.job.crew
        property= visit_schedule.job.property
        if current_user.user_type == "admin"
          admin_address(@crew,property,@address,@user)
        else
          user_address(@crew,property,@address,@user)
        end          
      end
    end
  end
  # Featch Admin Propertiy address
  def admin_address(crew,property,address,user)
    if !crew.blank?
      crew.each do |id|
        address  << "#{property.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{property.city rescue ""}, #{property.country rescue ""} "
        user << User.find(id)
     end
    else
      user << User.find(current_user.id)
      address  << "#{property.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{property.city}, #{property.country} "
    end
     @users= user.collect(&:marker_color) 
  end
  # Featch Member property address
  def user_address(crew,property,address,user)
    if !crew.blank?
      crew.each do |id|
        if (current_user.id == id.to_i)
          address  << "#{property.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{property.city}, #{property.country} "
          user << User.find(id)
        end
      end
    end
    @users= user.collect(&:marker_color)
  end
#Generate twilio token
  def generate_twilio_token
    capability = Twilio::Util::Capability.new $account_sid, $auth_token
    params = {'user_id' => current_user.id}
    capability.allow_client_outgoing "AP1f74ef185b275ff17db9f4192cc5f8a1" ,params
    @token = capability.generate
  end

# Get Today display data job quote and invoice
  def today_job_quote_invoice
    team_documents
    @addons_status = current_user.add_on_statuses
    @company_brands = current_user.company
    @team_members = current_user.team_members
    @quotes = Quote.where(:user_id=>current_user.id)
    @clients = Client.where(:user_id=>current_user.id)
    @jobs = Job.where(:user_id=>current_user.id)
    @job_overdue = @jobs.where('end_date < ? AND job_complete = ?', Date.today,false)
    @job_schedules = VisitSchedule.where(user_id: current_user.id, job_complete: false)
    @jobs_complete =  @jobs.where(job_complete: true)
    @jobs_today = Job.where('start_date<= ? AND user_id=? AND start_date >= ?',Date.today+6,current_user.id,Date.today)
  end

#Display Team document
  def team_documents
    get_lead_active
    if current_user.user_type == "admin"
      @documents_hr = current_user.documents.where(:file_type=>"hr_document")
      @documents_contract = current_user.documents.where(:file_type=>"contract_document")
      @documents_company = current_user.documents.where(:file_type=>"company_document")
    else
      @user= @team_member.user     
      @documents_hr = Document.where(:user_id=>@user.id,:file_type=>"hr_document")
      @documents_contract = Document.where(:user_id=>@user.id,:file_type=>"contract_document")
      @documents_company = Document.where(:user_id=>@user.id,:file_type=>"company_document")
      @documents_team = current_user.documents.where(:file_type=>"team_document")
    end
  end 

#Get active lead
  def get_lead_active
    get_center_location
    address_lead = current_user.properties.where(:lead=>true ,:pool_activity=>"lead")
    address_active = current_user.properties.where(:lead=>false ,:pool_activity=>"active")
    @address_lead=[]
    @address_active =[]
    address_lead.each do |property|
      res = Geocoder.search("#{property.street}  #{property.city} #{property.state} #{property.country}") rescue ""
      @address_lead << { lat: res[0].latitude,lon: res[0].longitude,description: "#{property.street}  #{property.city} #{property.state} #{property.country}"} if !res.blank?
    end
    address_active.each do |property|
      res = Geocoder.search("#{property.street}  #{property.city} #{property.state} #{property.country}") rescue ""
      @address_active << {lat: res[0].latitude,lon: res[0].longitude,description: "#{property.street}  #{property.city} #{property.state}"} if !res.blank?
    end
  end

#Get marker vendors  
  def get_marker 
    require 'open_weather' 
    @address = []
    @pref_vendors = []
    @vendor = current_user.vendor_setting
    @vendors = Vendor.all.where(:user_id => [current_user.id,nil])
    if !@vendor.blank?
      if @vendor.prefer_marker == "preference"
         @address = get_preference_vendors(@vendor,@pref_vendors)
      else
        @add = get_alladdress_miles(@vendors,@vendor)
        @add.collect{|p| @address << { name:"#{p.street} , #{p.city} ,#{p.zipcode}, <a href=/vendors/add_preference?vendors=#{p.id}&map=marker data-remote=true>Add Preference</a>", latitude: p.latitude, longitude: p.longitude}}
      end
    end
    vendors_locations
    get_vendors_radius(@vendor)
  end 

#Get vendors location
  def vendors_locations
    options = { units: "metric", APPID: WEATHER_APPID }
    res = OpenWeather::Current.city("#{current_user.street} ,#{current_user.city}", options) rescue ""
    @lat = res["coord"]["lat"] rescue "40.73"
    @lng = res["coord"]["lon"] rescue "-73.93"
  end  

#Get vendors radius
  def get_vendors_radius(vendor)
    if vendor.blank?
      @radius = 25
      # @icons = "green.png"
    elsif vendor.vendor_miles.blank?
      @radius =25
      @icons = "green-dot.png" if vendor.prefer_marker == "miles"
      @icons = "blue-dot.png" if vendor.prefer_marker == "preference"
    else
      @icons = "green-dot.png" if vendor.prefer_marker == "miles"
      @icons = "blue-dot.png" if vendor.prefer_marker == "preference"
      @radius =vendor.vendor_miles
    end
  end

#Get job months
  def get_job_months jobs
    @jobs_month=[]
    if !jobs.blank?
      jobs.each do |job|
        if !job.start_date.blank?
          if job.start_date.strftime("%m")==Date.today.strftime("%m")
            @count=check_job_invoice_genrate(job)
            if @count==0
              @jobs_month << job
            end
          end
        end  
      end 
    end
  end

#Display dashboard summary data
  def get_summary_data
    job_work_tab_contain
    @jobs_archived= archived_job
    @jobs_requires=requires_job
    @job_actives = active_job
    html_content = render_to_string partial: 'dashboards/dashboard_work' , :locals => {:@jobs_archived =>@jobs_archived,:@jobs_requires=>@jobs_requires,:@job_actives=>@job_actives,:@clients=>@clients,:@invoices=>@invoices,:@quotes_draft=>@quotes_draft,:@quotes_sent=>@quotes_sent,:@invoices_draft=>@invoices_draft,:@invoices_outstand=>@invoices_outstand,:@invoices_past=>@invoices_past}
    respond_to do |format|
      format.json { render json: { summary_data: html_content, status: 200 }}
    end
  end

  #Display dashboard quick links
  def get_quick_links
    html_content = render_to_string partial: 'home/quick_links'
    respond_to do |format|
      format.json { render json: { quick_links_data: html_content, status: 200 }}
    end
  end
  #Display weather
  def weather_data
    get_center_location
    if ((!current_user.city.blank?) && (!current_user.street.blank?))
      html_content = render_to_string partial: 'home/weather_address'
    else
      html_content = render_to_string partial: 'home/weather_ip'
    end
    respond_to do |format|
      format.json { render json: { weather_find_data: html_content, status: 200 }}
    end
  end
#Get map center location
  def get_center_location
    if !current_user.company.blank?
      if !current_user.company.street.blank?
        present_address(current_user.company.street,current_user.company.city)
      elsif ((!current_user.city.blank?) && (!current_user.street.blank?))
        present_address(current_user.street,current_user.city)
      else
        not_present_address
      end
    elsif ((!current_user.city.blank?) && (!current_user.street.blank?))
      present_address(current_user.street,current_user.city)
    else
      not_present_address
    end
  end

#User address not present 
  def not_present_address
    keys = {api: '9027ce61acb3e40733cb4173b5bd2124'}
    query = find_current_address("122.168.204.0") if Rails.env== "development"
    query = find_current_address(request.remote_ip) if Rails.env== "production"
    begin
      @barometer = find_current_barometer(query,keys)
    rescue
      query = query_for_lat_long(Rails.env == "development" ? "122.168.204.0" : request.remote_ip)
      @barometer = find_current_barometer(query,keys)
    end
    @lat = @barometer.query.split(",")[0] rescue ""
    @lng = @barometer.query.split(",")[1] rescue ""
  end

#User present address 
  def present_address(street,city)
    @street= street
    @city= city
    options = { units: "metric", APPID: WEATHER_APPID }
    res = OpenWeather::Current.city("#{street} ,#{city}", options) rescue ""
    @lat = res["coord"]["lat"]
    @lng = res["coord"]["lon"]
  end 

  private

    def archived_job
      @jobs_archives=[]
      if current_user.user_type=="admin"
        @jobs=Job.where(:user_id=>current_user.id)
      else
        user_admin_id=TeamMember.find_by_member_id(current_user.id).user_id
        @jobs=Job.where(:user_id=>user_admin_id)
      end
      if !@jobs.blank?
        @jobs.each do |job|
          if job.job_required== "Require Invoice"
            @count=check_job_invoice_genrate(job)
            if @count!= 0
              @jobs_archives<< job
            end
          end
        end
        return @jobs_archives
      end  
    end

    def active_job
      @jobs_active=[]
      if current_user.user_type=="admin"
        @jobs=Job.where(:user_id=>current_user.id)
      else
        user_admin_id=TeamMember.find_by_member_id(current_user.id).user_id
        @jobs=Job.where(:user_id=>user_admin_id)
      end
      if !@jobs.blank?
        @jobs.each do |job| 
        if job.job_required!= "Require Invoice"
            @count=check_job_invoice_genrate(job)
            if ((@count== 0) || (job.start_date == Date.today)) 
              @jobs_active<< job 
            end
          end
        end
        return @jobs_active
      end  
    end

    def requires_job
      @jobs_required=[]
      if current_user.user_type=="admin"
        @jobs=Job.where(:user_id=>current_user.id)
      else
        user_admin_id=TeamMember.find_by_member_id(current_user.id).user_id
        @jobs=Job.where(:user_id=>user_admin_id)
      end
      if !@jobs.blank?
        @jobs.each do |job|
          if job.job_required== "Require Invoice"
            @count=check_job_invoice_genrate(job)
            if @count== 0
              @jobs_required<< job
            end
          end
        end
        return @jobs_required
      end  
    end
end