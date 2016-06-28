class Api::V1::PasswordsController < Api::V1::ApiController
	before_filter :authenticate_user!, :except => [:create]
	skip_before_filter  :verify_authenticity_token

	def create
		
		@user = User.find_by_email(params[:email])
		if @user.present?
		 @user.send_reset_password_instructions
		 render  :json=>{:status => "Success" }
		else
		  render :json=>{:status => "Failure" }
		end
	end
end