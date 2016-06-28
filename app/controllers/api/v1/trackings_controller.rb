class Api::V1::TrackingsController < Api::V1::ApiController
	skip_before_filter  :verify_authenticity_token

	def update_coordinates
		if !current_user.blank?
			@track = current_user.tracks.new(track_params)
			if @track.save
				render :status=>200, :json=>@track.as_json
			else
				render  :json=>{:status => "something went wrong" }
			end
		else
			render  :json=>{:status => "Failure Please login" }
		end
	end

	def show_points
		if !current_user.blank?
			@trackings =[]
			if current_user.user_type=="admin"
				@team = current_user.team_members
				@team.each do |team|
					user = User.find(team.member_id)
					tracking = user.tracks.where("DATE(created_at) = ? and active = ?", Date.today,true)
					@trackings << tracking if !tracking.blank?
				end
				render :status=>200, :json=>@trackings.as_json
			else
				render  :json=>{:status => "something went wrong" }
			end
		else
			render  :json=>{:status => "Failure Please login" }
		end
	end

	def deactive_points
		if !current_user.blank?
			@trackings = current_user.tracks.where("DATE(created_at) > ? and active = ?", Date.today-7,true)
			@trackings.each do |track|
				track.update(:active=>false)
			end
			render :status=>200, :json=>@trackings.as_json
			else
			render  :json=>{:status => "Failure Please login" }
		end
	end


	private

		# def track_params
		# 	params.require(:track).permit(:latitude,:longitude,:user_id,:active)
		# end
		def track_params
            params.permit(:latitude,:longitude,:user_id,:active)
        end
	 	
	 	def current_user
  		User.find(params[:user_id]) rescue ""
  	end

end
