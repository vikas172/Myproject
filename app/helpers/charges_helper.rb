module ChargesHelper

	def addons_total
		return 0
	end

	def get_add_on_status(user_add_on, add_on)
		unless current_user.add_on_statuses.where(add_on: add_on).first.blank?
			return true if current_user.add_on_statuses.where(add_on: add_on).first.status
		end
	end

	def discount_coupon(user,coupon)
		if user.plan_type=="solo"
			@amount="19.95"
		elsif user.plan_type=="team"
			@amount="29.95"
		elsif user.plan_type=="business"
			@amount="49.95"
		end
		return discount_amount=(@amount.to_f/coupon.percent_off)
	end

	def plan_type(user)
		if user.plan_type=="solo"
			amount="1995"
		elsif user.plan_type=="team"
			amount="2995"
		elsif user.plan_type=="business"
			amount="4995"
		end 
	end

	def find_total_payment(payment)
		refund_amount=payment.amount_refunded.to_f/100
		payment_amount = payment.amount.to_f/100
		return payment_amount - refund_amount
	end

	def plan_last_date(current_user)
		@charge=Charge.where(:user_id=> current_user.id).first
		return @charge.created_at.to_date+30
	end
end
