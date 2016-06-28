class Api::V1::BasicTasksController < Api::V1::ApiController
	skip_before_filter  :verify_authenticity_token

  def index
		if !current_user.blank?
			if current_user.user_type=="user"
				user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
				basic_tasks = BasicTask.where(:user_id=>user_type_id)
			else
				basic_tasks = BasicTask.where(:user_id=>current_user.id )
			end
			render :status=>200, :json=>basic_tasks.as_json
		else
			render  :json=>{:status => "Failure Please login" }
		end
  end


	def new
	end

	def create
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					@user = User.find(user_type_id)
				else
					@user = current_user
				end

				basic_task= BasicTask.new(basic_task_params)
				basic_task.assigned_to = ["#{params[:user_id]}"]
        basic_task.user_id = @user.id
				if basic_task.save
					render :status=>200, :json=>basic_task.as_json
				else
					render :json=>{:status => "Basic task not save some failure occur"}
				end
			else
				render :json=>{:status => "Failure match not found"}
			end		
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	def show
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					basic_task = BasicTask.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					basic_task = BasicTask.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if basic_task
					render :status=>200, :json=>basic_task.as_json
				else
					render :status=>200, :json=>{:status => "Basic task not found"}
				end
			else
			  render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end


	def edit
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					basic_task = BasicTask.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					basic_task = BasicTask.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if basic_task
					render :status=>200, :json=>basic_task.as_json
				else
					render :status=>200, :json=>{:status => "basic task not found"}
				end
			else
				render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end


	def update_task
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					basic_task = BasicTask.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					basic_task = BasicTask.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if basic_task.update(basic_task_params)
					render :status=>200, :json=>basic_task.as_json
				else
					render :status=>200, :json=>{:status => "basic task failure occur"}
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
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					basic_task = BasicTask.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					basic_task = BasicTask.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if basic_task
					basic_task.destroy
					render :status=>200, :json=>{:status => "basic task Deleted sucessfully"}
				else
					render :status=>200, :json=>{:status => "basic task not found"}
				end
			else
			  render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	def today_task
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
			  basic_tasks =current_user.basic_tasks.where(:start_at_date=> Date.today)
			  if basic_tasks.blank?
			  	render :json=>{:status=>"TASK NOT PRESENT"}
			  else
			  	render :status=>200 ,:json=>basic_tasks.as_json
			  end
			else
				render :json=>{:status => "Failure match not found"}
			end
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	private
		def basic_task_params
	    params.require(:basic_task).permit(:title, :description,:start_at_date,:end_at_date, :start_at_time, :end_at_time, :all_day, :repeat, :is_completed, :complete_by, :completed_date, :assigned_to,:user_id)
	  end

	  def current_user
	  	User.find(params[:user_id]) rescue ""
	  end
end