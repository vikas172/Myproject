class Api::V1::ChargesController < Api::V1::ApiController
	skip_before_filter  :verify_authenticity_token

	def charge_create
		if !current_user.blank?
			if (params[:stripeToken].present? && params[:email].present? && params[:amount].present?)

				customer = Stripe::Customer.create(
		      :email => params[:email],
		      :card  => params[:stripeToken]
		    )

		    charge = Stripe::Charge.create(
		      :customer    => customer.id ,
		      :amount      => (params[:amount].to_f*100).to_i,
		      :description => 'payment-api transaction',
		      :currency    => 'usd'
		    )  rescue ""

		    if !charge.blank?
		    	render  :json=>{:status => "Payment successfully done!" }
	      else
				  render  :json=>{:status => "Something went Wrong, Please try again" }
			  end
			else
				render  :json=>{:status => "Please send email and amount" }
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