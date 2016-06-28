class PhoneNumber < ActiveRecord::Base
  belongs_to :user
	def generate_pin
  	self.pin = rand(0000..9999).to_s.rjust(4, "0")
  	save
	end
	def verify(entered_pin,user_id,mobile_number)
		if self.pin == entered_pin
  		update(verified: true) 
  		@user = User.find(user_id)
  		@user.mobile_number = mobile_number
  		@user.verified =true
  		@user.save
		end
	end
end
