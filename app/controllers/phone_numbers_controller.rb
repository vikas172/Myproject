class PhoneNumbersController < ApplicationController

#Check phone validate or not
	def check_validate
		@phone_number = PhoneNumber.new 
	end

#Create phone number object and also generate the pin and send to the number
	def create
		@phone_number = PhoneNumber.create(phone_number: params[:phone_number][:phone_number],user_id: current_user.id)
		@phone_number.generate_pin
		@twilio_sms=twilio_client.messages.create(to: @phone_number.phone_number,from: "+1 256-272-4758",body: "Your PIN is #{@phone_number.pin}") rescue ""
		if @twilio_sms.blank?
			@phone_number.delete
		end
		respond_to do |format|
			format.js # render app/views/phone_numbers/create.js.erb
		end
	end

#call this method to get credential 
	def twilio_client
		Twilio::REST::Client.new("ACd869a002f0e70e88052135df47fbcc3f","af4736a568708a4bd4e5735b3c3f5fec")
	end

#resend pin if not present
	def resend_code
		@phone_number= current_user.phone_number
		@phone_number.generate_pin
		@twilio_sms=twilio_client.messages.create(to: @phone_number.phone_number,from: "+1 256-272-4758",body: "Your PIN is #{@phone_number.pin}") rescue ""
	end

#verify user submit pin
	def verify
		@phone_number = current_user.phone_number
		if params[:hidden_phone_number] != current_user.mobile_number
			current_user.mobile_number = params[:hidden_phone_number]
			current_user.save
			@phone_number.phone_number =  params[:hidden_phone_number]
			@phone_number.save
		end
		@phone_number.verify(params[:pin],current_user.id,params[:hidden_phone_number])
			respond_to do |format|
			format.js
		end
	end
end
