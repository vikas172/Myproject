class SupportsController < ApplicationController
	before_action :authenticate_user!
	protect_from_forgery with: :null_session

#support new object initial
	def new
		@support=Support.new
	end

#support object created
	def create
		@support=Support.new(support_params)
		if @support.save
			redirect_to request.referrer ,:notice=> "Thank you for being with us we will contact you shortly."
		else
			redirect_to request.referrer ,:notice=> "Some problem is arise please try again."
		end	
	end
	
	private

	  def support_params
	    params.require(:support).permit(:email, :title, :description, :phone_number,:file,:about)
	  end
end
