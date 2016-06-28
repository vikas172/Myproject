class Api::V1::RegistrationsController < Api::V1::ApiController
	 before_filter :authenticate_user!, :except => [:create]
	 skip_before_filter  :verify_authenticity_token
	  respond_to :json
	  def create
	  	
	  user =  User.new(:company_name=>params[:company_name],:email=>params[:email],:password=>params[:password],:password_confirmation=>params[:password_confirmation],:full_name=>params[:full_name],:user_type=>"admin",:plan_type=>params[:plan_type])
		if user.save
		  render  :json=>{:status => "Success" }
		return
		else
		  warden.custom_failure!
		  render :json=> {:status => 0,:message=>user.errors}
		end
	  end
end
