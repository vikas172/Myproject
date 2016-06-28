module VendorsHelper

	def get_vendor_location_name(vendor_id)
		vendor=Vendor.find(vendor_id)
		return vendor.location_name
	end

	def get_alladdress_miles(vendors,vendor)
		if !current_user.street.blank?
			return Vendor.near("#{current_user.street},#{current_user.city},#{current_user.state}", vendor.try(:vendor_miles))
	  elsif !current_user.company.blank?
	  	if !current_user.company.street.blank?
				return Vendor.near("#{current_user.company.street},#{current_user.company.city},#{current_user.company.state}", vendor.try(:vendor_miles))
	  	else
				get_data_ipaddress(vendor)
	  	end
	  else
	  	get_data_ipaddress(vendor)
	  end	
	end

	def get_data_ipaddress(vendor)
	  data = Geocoder.search("122.168.204.0") if Rails.env== "development"
    data = Geocoder.search(request.remote_ip) if Rails.env== "production"
    return Vendor.near("#{data[0].data['city']},#{data[0].data['country_code']}}", vendor.try(:vendor_miles))
	end

end
