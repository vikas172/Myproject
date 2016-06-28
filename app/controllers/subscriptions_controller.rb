class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
	include SubscriptionsHelper
	protect_from_forgery with: :null_session

	def plan
	end

#change subscription plan
	def change_plan
		@plan_view = pricing_plan_change(current_user,params)
		@charge=Charge.where("user_id =? AND account_status= ?",current_user.id,current_user.plan_type).last
	  if @charge.blank?
	  	 @base_charge= plan_type_price(params)
	  else
	  	plan_choose= amount_type_price(params)
	  	amount = plan_choose - @plan_view
	  	@base_charge = (amount/100).round(2)
	  end
	end

#downgrade subscription plan
	def downgrade_plan
		charge=Charge.where("user_id =? AND account_status= ?",current_user.id,current_user.plan_type).last
		transaction = Stripe::Charge.retrieve(charge.transaction_id)
    sucess_refund=transaction.refunds.create(:amount=>(params[:amount].to_f*100).to_i) rescue false    
    if sucess_refund
    	current_user.plan_type = params[:plan_type]
    	current_user.save
    	redirect_to plan_subscriptions_path ,:notice=>"Your plan is downgrade"
    else
    	redirect_to plan_subscriptions_path ,:notice=>"Your are able to downgrade after #{charge.active_date+7}"
    end
	end
end
