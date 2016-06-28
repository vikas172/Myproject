class Api::V1::TimesheetsController < Api::V1::ApiController
	skip_before_filter  :verify_authenticity_token

	def index
		if !current_user.blank?
		  timesheets = Timesheet.where(:user_id=>current_user.id )
			render :status=>200, :json=>timesheets.as_json
		else
			render  :json=>{:status => "Failure Please login" }
		end
	end

	def show
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				timesheet = Timesheet.where(:user_id=>current_user.id ,:id=>params[:id]).first
				if timesheet
					render :status=>200, :json=>timesheet.as_json
				else
					render :status=>200, :json=>{:status => "Timesheet not found"}
				end
			else
			  render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	def new
	end

	def create
		if !current_user.blank?
			timesheet= Timesheet.new(timesheet_params)
		 	timesheet.user_id = current_user.id
		 	timesheet.day = Date.today
		 	timesheet.start_date = Date.today
			if timesheet.save
				render :status=>200, :json=>timesheet.as_json
			else
				render :json=>{:status => "Timesheet not save some failure occur"}
			end
		else
			render  :json=>{:status => "Failure Please login" }
		end
	end

	def edit
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				timesheet = Timesheet.where(:user_id=>current_user.id ,:id=>params[:id]).first
				if timesheet
					render :status=>200, :json=>timesheet.as_json
				else
					render :status=>200, :json=>{:status => "Timesheet not found"}
				end
			else
				render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end		
	end

	def update_timesheet
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				timesheet = Timesheet.where(:user_id=>current_user.id ,:id=>params[:id]).first
				if timesheet.update(timesheet_params)
					render :status=>200, :json=>timesheet.as_json
				else
					render :status=>200, :json=>{:status => "Timesheet failure occur"}
				end
			else
				render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end		
	end

	def destroy
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				timesheet = Timesheet.where(:user_id=>current_user.id ,:id=>params[:id]).first
				if timesheet
					timesheet.destroy
					render :status=>200, :json=>{:status => "Timesheet Deleted sucessfully"}
				else
					render :status=>200, :json=>{:status => "Timesheet not found"}
				end
			else
				render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end		
	end

	private
		def timesheet_params
			params.require(:timesheet).permit(:user_id,:start_date,:auto_start_timer,:job_id,:label,:note,:start_time, :end_time, :duration,:day,:custom_category_id,:billable)
		end
		def current_user
			User.find(params[:user_id]) rescue ""
		end
end