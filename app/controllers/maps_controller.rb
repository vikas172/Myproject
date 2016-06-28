class MapsController < ApplicationController
	include JobsHelper
	require 'open_weather'

#Zoom option to display the marker on full with view
	def zoom
		@job=Job.where(:user_id=>current_user.id).collect(&:id)
		@today_schedule=VisitSchedule.where(:job_id=> @job,:start_date=>Date.today,:job_complete=>false)
		@address= []
		@user=[]
		if !@today_schedule.blank?
			@today_schedule.each_with_index do |visit_schedule,index|
				@crew = visit_schedule.job.crew
				property= visit_schedule.job.property
				if !@crew.blank?
					@crew.each do |id|
						@address  << "#{property.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{property.city}, #{property.country} "
						@user << User.find(id)
					end
				else
					@user << User.find(current_user.id)
					@address  << "#{property.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{property.city}, #{property.country} "
				end
				@users= @user.collect(&:marker_color)
			end
		end
	end

#Click on the optmize button to get all the visit scheduled pool address
	def optimize
		@waypoint_geo1=[]
		@properties=[]
		get_schedule_job
		if !@jobs.blank?
			@job_visits=VisitSchedule.where(:job_id=> @jobs,:start_date=>Date.today,:job_complete=>false).collect(&:job_id)
			@job_visits.each do |job_id|
				@properties << Job.find(job_id).property
			end
		end
		@waypoint_geo1=[]
		@property_routes_pdf=[]
		if !@properties.blank?
			@properties.each do |property|
				@property_routes_pdf << property.id
				@waypoint_geo1 << "#{property.street}, #{property.street2}, #{property.city}, #{property.country} "
			end
		end
	end

#Show the routes view to the end user
	def routes
		
		@waypoint_geo1=[]
		@properties=[]
		@jobs=get_schedule_job
		visit_schedule(@jobs,$all_property)
		@waypoint_geo1=[]
		@properties_add=[]
		if !$all_property
			if !@properties.blank?
				@properties.each do |property|
					#@waypoint_geo1 << "#{property.street}, #{property.street2}, #{property.city}, #{property.country} "
					res = Geocoder.search("#{property.street}, #{property.street2}, #{property.city}, #{property.country}") rescue ""
					@waypoint_geo1 << {lat: res[0].latitude,lon: res[0].longitude,description:"#{property.street}, #{property.street2}, #{property.city}, #{property.country}"} if !res.blank?
				end
			end
		else 
			$all_property.each do |property_id|
				if property_id.to_i != 0
				property=Property.find(property_id)
				@properties << property
				@waypoint_geo1 << "#{property.street}, #{property.street2}, #{property.city}, #{property.country} "
				else
				@waypoint_geo1 << "#{current_user.street}, #{current_user.city}, #{current_user.state}, #{current_user.zipcode}"
				end
			end
		end 
	end

#Get scheduled for job and display on map
	def get_schedule_job
		if current_user.user_type=="admin"
			jobs= Job.where(:user_id=>current_user.id).collect(&:id)
		else
			jobs=[]
			user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
			user_admin= User.find(user_type_id)
			@addons_admin = user_admin.add_on_statuses
			@job=Job.where(:job_complete=>false,:user_id=>user_type_id)
			@job.each do |job|
				if !job.crew.blank?
					if job.crew.include? current_user.id.to_s 
						jobs << job.id
					end
				end
			end
		end
	end

#Route action call this method to get today visit of jobs
	def visit_schedule(jobs,all_property)
		@properties_previous=[]
		@properties=[]
		if !jobs.blank?
			job_visit_previous=VisitSchedule.where("start_date<=? AND job_id IN (?) AND job_complete=?",Date.today,jobs,false).collect(&:job_id).uniq
			job_visit=VisitSchedule.where(:job_id=> jobs,:start_date=>Date.today,:job_complete=>false).collect(&:job_id)
			job_visit.each do |job_id|
				if !all_property 
					@properties << Job.find(job_id).property
				end
			end
			job_visit_previous.each do |job_id|
				if !all_property
					@properties_previous << Job.find(job_id).property
				end
			end
		end
	end

#Route optimize and get all points 
	def route_optimize
		$optimize_route=true
		params[:add_point]=[] if params[:add_point].blank?
		@points = params[:add_point] if !params[:add_point].blank?
		get_start_point(params)
		get_end_point(params,@property_list)
		$all_property=@property_all
		optimize_start_point(params)
		optimize_end_point(params)
		get_multi_points(@points)
		total_address = @points.count
		if total_address >= 10 
			flash[:error] = "Please select less than 8 cooridinate"
			$optimize_route=false
			redirect_to routes_path
		end	

	end

#Get start point of the routes
	def get_start_point(params)
		if (params[:start_point].to_i !=0)
			@property_list=params[:add_point].insert(0,params[:start_point]) if !params[:start_point].nil?
		elsif params[:start_point].include? "user_"
			@property_list =params[:add_point].insert(0,"user")
		else
			@property_list =params[:add_point].insert(0,"company")  
		end
	end

#Get end point of the routes
	def get_end_point(params,property_list)
		if (params[:end_point].to_i !=0)
			@property_all=params[:add_point].insert(property_list.count,params[:end_point]) if !params[:end_point].nil?
		elsif params[:end_point].include? "user_"
			@property_all =params[:add_point].insert(property_list.count,"user")
		else
			@property_all =params[:add_point].insert(property_list.count,"company")
		end
	end

#get optimize start points
	def optimize_start_point(params)
		if (params[:start_point].to_i !=0)
			start_point=Property.find(params[:start_point]) if !params[:start_point].blank?
			$optimize_start_point="#{start_point.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{start_point.city}, #{start_point.country} " if !start_point.blank?
		else
			$optimize_start_point=get_start_points(current_user,params)
		end
	end

#get optimize end points 
	def optimize_end_point(params)
		if (params[:end_point].to_i !=0)
			end_point=Property.find(params[:end_point]) if !params[:end_point].blank?
			$optimize_end_point="#{end_point.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{end_point.city}, #{end_point.country} " if !end_point.blank?
		else
			$optimize_end_point=get_end_points(current_user,params)
		end
	end

#get multiple points select on the select box previous non completed points also display
	def get_multi_points(points)
		$multipoint =[]
		if !points.blank?
			points.each do |add_point|
				if add_point == "user"
					$multipoint << "#{current_user.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{current_user.city}, #{current_user.state}, #{current_user.zipcode}"
				elsif add_point == "company"
					$multipoint << get_multipoints(params,current_user)
				else
					property = Property.find(add_point) 
					$multipoint << "#{property.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{property.city}, #{property.country} "
				end
			end
		end
	end

#After route Optimization points contain pdf generated
	def routes_optization_pdf
		if !params[:property_details].blank?
			@property=[]
			@properties_id=params[:property_details].split()
			@properties_id.each do |property_id|
				@property<< Property.find(property_id)
			end
		end  
		html = render_to_string(:layout => false )
		kit = PDFKit.new(html, :page_size => 'Letter')
		send_data(kit.to_pdf, :filename =>"routes_optimization_pdf.pdf", :type => 'application/pdf')
	end

#Generate routes pdf and mail to client
	def route_pdf_email
		if !params[:property_details].blank?
			@property=[]
			@properties_id=params[:property_details].split()
			@properties_id.each do |property_id|
				@property<< Property.find(property_id)
			end
		end  
		html = render_to_string(:layout => false )
		kit = PDFKit.new(html, :page_size => 'Letter')
		thepdf= kit.to_file("#{Rails.root}/tmp/#{current_user.id}.pdf")
		UserMailer.route_optimization_email(thepdf,current_user).deliver
		FileUtils.rm_rf("#{Rails.root}/tmp/#{current_user.id}.pdf")
		if request.referrer.include?"maps"
			redirect_to optimize_maps_path
		else
			redirect_to routes_path
		end
	end


#Insert points into routes
	def insert_at_route
		@property=Property.find(params[:property_id])
		@property.add_route=true
		@property.save
		redirect_to routes_path
	end

#Remove points into routes
	def remove_at_route
		if !params[:property_id].nil?
			@property=Property.find(params[:property_id])
			@property.add_route=false
			@property.save
		else
			$optimize_route=nil
			$all_property=nil
			@clients=current_user.clients
			@clients.each do |client|
				client.properties.each do |property|
					if property.add_route==true
						property.add_route=false
						property.save
					end
				end
			end
		end
		redirect_to routes_path
	end

#Assign team 
	def assigned_team
		@property_ids=[]
		@job=current_user.jobs.where(:job_type=>"recurring_contract",:job_complete=>false) if !current_user.jobs.blank?
	  @address =[]
	  if !@job.blank?
		  @job.each do |job|
		  	property = job.property
		  	options = { units: "metric", APPID: WEATHER_APPID }
		  	res = OpenWeather::Current.city("#{property.street + ","+property.city + ","+property.state}", options) rescue ""
		  	@address << {location: "#{property.street}  #{property.city} #{property.state}",lat: res["coord"]["lat"],lng: res["coord"]["lon"],job_id: job.id,name:current_user.username} if !res["coord"].blank?
		  end
		end
	end

#Change assigned team members
	def change_assign
		@job = Job.find(params[:job_id])
		@team_member = current_user.team_members
	end

#reassign the job to the teammember or admin
	def reassign
		job= Job.find(params[:job_id])
		job.crew = params[:job][:crew] if !params[:job][:crew].blank?
		job.save
		visit_schedules= job.visit_schedules
		if !visit_schedules.blank?
			visit_schedules.each do |schedule|
				schedule.crew = schedule.job.crew if !params[:job][:crew].blank?
				schedule.save
			end
		end
		redirect_to :back
	end

#Display marker on map
	def map_show
		property = Property.find(params[:property_id])
		options = { units: "metric", APPID: WEATHER_APPID }
		res = OpenWeather::Current.city("#{property.street + ","+property.city}",options) rescue ""
	  @lat = res["coord"]["lat"]
	  @lon = res["coord"]["lon"]
	end

#Calulate estimate through area
	def property_estimate
		property = Property.find(params[:property_id]) if !params[:property_id].blank?
		property.estimate_map = (params[:area].to_f*3.28*6*7.48052).round(2) rescue "0.0"
		property.save if !params[:property_id].blank?
	end

#Get list of lead and address of the pools
	def lead
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

#call method to the lead with no address
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

#call method to the lead with address present
	def present_address(street,city)
		@street= street
		@city= city
		options = { units: "metric", APPID: WEATHER_APPID }
	  res = OpenWeather::Current.city("#{street} ,#{city}", options) rescue ""
		@lat = res["coord"]["lat"]
		@lng = res["coord"]["lon"]
	end

#Display address on the map
	def display_address
		@address = []
		if !params[:address].blank?
			params[:address].each do |add|
				sw = Geokit::LatLng.new(add[1].values[0], add[1].values[1])
				address=Geocoder.search( sw)
				if (address.first.data["address_components"][6]["types"] == ["postal_code"])
					@address << address.first.data["address_components"][0]["short_name"] +" " +address.first.data["address_components"][1]["short_name"] +", "+address.first.data["address_components"][3]["long_name"] +", "+address.first.data["address_components"][4]["short_name"] +","+ address.first.data["address_components"][5]["short_name"] + ", "+ address.first.data["address_components"][6]["short_name"] rescue " "
			  else
					@address << address.first.data["address_components"][0]["short_name"] +" " +address.first.data["address_components"][1]["short_name"] +", "+address.first.data["address_components"][3]["long_name"] +", "+address.first.data["address_components"][4]["short_name"] +","+ address.first.data["address_components"][5]["short_name"] + ", "+ address.first.data["address_components"][7]["short_name"] rescue " "
			  end
			end
		end
	end

#Create new leads
	def create_lead
		@clients= current_user.clients
		@address = Hash[(0...params[:address].count).zip params[:address]].to_a
	end

#Add leads
	def add_lead
		@client = Client.where(:personal_email=>"lead@mailinator.com",:company_name=>"lead_company",:user_id=>current_user.id)
    if @client.first.blank?
    	client=Client.create(:initial=>"Mr.",:first_name=>"Leads",:last_name=>"Placeholder",:company_name=>"lead_company",:mobile_number=>"+11110001110",:personal_email=>"lead@mailinator.com",:user_id=>current_user.id)
		else
			client = @client.first
		end
		if !params[:filters].blank?
			params[:filters].keys.each do |address|
				address1 = address.split(",")
				if (address1[2].length <= 3)
					property =Property.new(:street=>address1[0],:city=>address1[1].gsub(/\s+/, ""),:state=>address1[2].gsub(/\s+/, ""),:zipcode=>address1[4].gsub(/\s+/, ""),:country=>address1[3].gsub(/\s+/, ""),:lead=>true,:user_id=>current_user.id,:pool_activity=>"lead",:client_id=>client.id)
			  else
			  	property =Property.new(:street=>address1[0],:city=>address1[1].gsub(/\s+/, ""),:state=>address1[3].gsub(/\s+/, ""),:zipcode=>address1[4].gsub(/\s+/, ""),:country=>address1[3].gsub(/\s+/, ""),:lead=>true,:user_id=>current_user.id,:pool_activity=>"lead",:client_id=>client.id)	
			  end
			  property.tag_list.add(params[:tags]) if !params[:tags].blank?
			  property.source = params[:source] if !params[:source].blank?
			  property.save
			end
		end
		redirect_to :back
	end

#Add marker on the map 
	def add_marker
		@radius = 25
		@lat = res["coord"]["lat"] rescue "40.73"
    	@lng = res["coord"]["lon"] rescue "-73.93"
    	# @icons = "blu-circle.png" 
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
end

private
   def get_preference_vendors(vendor_setting,pref_vendors)
      if !vendor_setting.preference_vendor.blank?
        vendor_setting.preference_vendor.each do |id|
          p = Vendor.find(id)
          pref_vendors << { name:"#{p.street} , #{p.city} ,#{p.zipcode} , <a href=/vendors/add_preference?vendors=#{p.id}&map=marker data-remote=true>Add Preference</a>", latitude: p.latitude, longitude: p.longitude}
        end
        return pref_vendors
      end
  end
  def vendors_locations
    options = { units: "metric", APPID: WEATHER_APPID }
    res = OpenWeather::Current.city("#{current_user.street} ,#{current_user.city}", options) rescue ""
    @lat = res["coord"]["lat"] rescue "40.73"
    @lng = res["coord"]["lon"] rescue "-73.93"
  end
  def get_alladdress_miles(vendors,vendor)
		if !current_user.street.blank?
			return Vendor.near("#{current_user.street},#{current_user.city},#{current_user.state}", vendor.try(:vendor_miles))
	  elsif !current_user.company.blank?
	  	if !current_user.company.street.blank?
				return Vendor.near("#{current_user.company.street},#{current_user.company.city},#{current_user.company.state}", vendor.try(:vendor_miles))
	  	else
				get_data_ipaddress(vendor)
	  	end
	  else
	  	get_data_ipaddress(vendor)
	  end	
	end
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

  