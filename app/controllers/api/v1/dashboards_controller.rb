class Api::V1::DashboardsController < Api::V1::ApiController
	skip_before_filter  :verify_authenticity_token
	require 'open_weather'
	def weather

		if current_user
			if current_user.street.blank?
				keys = {api: 'ddc0472200ecbb715cf9901ded8320cb'}
				query = Barometer::Query.new("122.168.204.0")
				barometer = Barometer::ForecastIo.call(query, keys: keys)
				list_value = OpenWeather::Forecast.geocode(barometer.query.split(",")[0].to_f,barometer.query.split(",")[1].to_f)["list"] rescue ""
		 	else
		    options = { units: "metric", APPID: "45c5cb2f83d12744849fd8797b8f19ac" }
		    res = OpenWeather::Current.city("#{current_user.street + ","+current_user.city}", options) rescue ""
				list_value = OpenWeather::Forecast.geocode(res["coord"]["lat"],res["coord"]["lon"], options)["list"] rescue "" 
		 	end

		 	@display=[]
		 	if !list_value.blank?
	 			list_value.each do |list_val|  
	      	@date = list_val["dt_txt"].to_date
	        if @date != @l_date
	        	@display << list_val
	        end
	        @l_date = @date
	      end
	    end  
		  render :status=>200, :json=>@display.as_json
		else
			render  :json=>{:status => "Failure Please login" }	
		end
	end
	def username
		if current_user
			if current_user.id == params[:user_id].to_i
				render :json=>{:first_name=>current_user.first_name,:last_name=>current_user.last_name}
			else
				render :json=>{:status => "Failure match not found"}
			end	
		else
			render  :json=>{:status => "Failure Please login" }	
		end		
	end


	private
	def current_user
		User.find(params[:user_id]) rescue ""
	end


end