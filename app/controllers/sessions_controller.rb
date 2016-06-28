class SessionsController < Devise::SessionsController
	layout false
	def create
		if current_user
			if current_user.user_type=="user"
				@team_member=TeamMember.find_by_member_id(current_user.id)
				if @team_member.login_access==true
					if @team_member.active==true
				  	super
				  else
					  session.destroy
						flash[:error] = "User Deactive Please try after some time"
						redirect_to new_user_session_path
				  end	
				else
					session.destroy
					flash[:error] = "Permission denied"
					redirect_to new_user_session_path
				end  
			else
				super
			end
	  else
	  	super
	  end	
	end
end
