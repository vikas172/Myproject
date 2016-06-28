module PropertiesHelper
	def client_name(property)
	  return property.client.try(:first_name) rescue "" +" "+property.client.try(:last_name) rescue "" 
	end

	def display_client_name(client_id)
		@client= Client.find(client_id)
	  return @client.try(:initial) rescue "" + " " + @client.try(:first_name) rescue "" + " " + @client.try(:last_name) rescue ""  
	end

	def property_street(property)
		return property.try(:street) rescue "" +" "+ property.try(:street2) rescue ""
	end

	def complete_basic_property(customer)
		User.find(customer).full_name
	end

	def assign_user_fullname(assign_id)
		User.find(assign_id).full_name
	end

	def market_source_name(property)
		if !property.market_source.blank?
			return MarketSource.find(property.market_source).source_name rescue ""
		else
			return ""
		end
	end

	def get_email_notification(id)
		return EmailNotification.find(id) rescue ""
	end

	def get_property_note(id)
		return Note.find(id) rescue ""
	end

	def get_property_sms(id)
		return PropertySms.find(id) rescue ""
	end

	def get_property_call(id)
		return PropertyCall.find(id) rescue ""
	end
end
