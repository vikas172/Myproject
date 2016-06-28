module SubscriptionsHelper
	def plan_activation_solo(user)
		if user.plan_type== "solo"
      "solo_active"
		end
	end

	def plan_activation_team(user)
		if user.plan_type== "team"
      "team_active"
		end
	end

	def plan_activation_business(user)
		if user.plan_type== "business"
      "business_active"
		end
	end


	def pricing_plan_change(user,params)
		current_plan = current_user.plan_type 
		change_plan = params[:plan_type]
		charge_present=Charge.where("user_id =? AND account_status= ?",current_user.id,current_user.plan_type).last
		
		if current_plan == "solo"
		  if charge_present.blank?
		  	if current_user.created_at.to_date+ 15 > Date.today
		  		current_user.plan_type=change_plan
		  		current_user.save
		  	else
		  		return false
		  	end
		  else
		  	active_date=charge_present.active_date
		  	day_used=(Date.today-active_date).to_i
		  	amount=1995
		  	per_day= amount.to_f/30
		  	used_plan = per_day * day_used
		  	amount_remaining = amount - used_plan
		  end
		elsif current_plan == "team"
			if charge_present.blank?
		  	if current_user.created_at.to_date+ 15 > Date.today
		  		current_user.plan_type=change_plan
		  		current_user.save
		  	else
		  		return false
		  	end
		  else
		  	active_date=charge_present.active_date
		  	day_used=(Date.today-active_date).to_i
		  	amount=2995
		  	per_day= amount.to_f/30
		  	used_plan = per_day * day_used
		  	amount_remaining = amount - used_plan
		  end
		elsif current_plan == "business"
			if charge_present.blank?
		  	if current_user.created_at.to_date+ 15 > Date.today
		  		current_user.plan_type=change_plan
		  		current_user.save
		  	else
		  		return false
		  	end
		  else
		  	active_date=charge_present.active_date
		  	day_used=(Date.today-active_date).to_i
		  	amount=4995
		  	per_day= amount.to_f/30
		  	used_plan = per_day * day_used
		  	amount_remaining = amount - used_plan
		  end
		end	
	end



	def plan_type_price(params)
		if params[:plan_type]=="solo"
			amount="19.95"
		elsif params[:plan_type]=="team"
			amount="29.95"
		elsif params[:plan_type]=="business"
			amount="49.95"
		end 
	end


	def amount_type_price(params)
		if params[:plan_type]=="solo"
			amount=1995
		elsif params[:plan_type]=="team"
			amount=2995
		elsif params[:plan_type]=="business"
			amount=4995
		end 
	end
end
