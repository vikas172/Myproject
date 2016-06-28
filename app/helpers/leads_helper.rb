module LeadsHelper

	def import_property_csv(row)
		country = Carmen::Country.named(row[9]).alpha_2_code rescue ""

    @client= Client.new(:initial => row[0], :first_name => row[1], :last_name => row[2], :company_name => row[3], :street1 => row[4], :street2 => row[5], :city => row[6], :state => row[7], :zip_code => row[8],:country=>country ,:phone_number => row[10],:mobile_number=>row[12],:personal_email=>row[13])
    if @client.first_name.blank?
    	@client.first_name ="lead"
    end
    if @client.last_name.blank?
    	@client.last_name ="placeholder"
    end
    if @client.company_name.blank?
    	@client.company_name ="leads"
    end
    if @client.mobile_number.blank?
    	@client.mobile_number ="0000000000"
    end
    if @client.personal_email.blank?
    	@client.personal_email ="lead@mailinator.com"
    end
 
    @client.user_id=current_user.id
    @client.save
    if !@client.id.blank?
    	if !row[14].blank?
	      @property = @client.properties.new(:street => row[14],:street2=>row[15], :city => row[16], :state => row[17],  :zipcode => row[18],:country => row[19],:latitude => row[20],:longitude => row[21],:pool_name => row[22],:pool_activity => row[23],:pool_type => row[24],:pool_volume => row[25],:pool_volume2 => row[26],:pool_gate_code => row[27],:pool_lifeguards => row[28],:pool_notes => row[29],:market_source => row[30],:lead => row[31])
			  @property.tag_list.add(row[32])
			  @property.user_id = current_user.id
              if !params[:pool_tag].blank?
                @property.tag_list = params[:pool_tag]
              end
              if !params[:source].blank?
                @property.source = params[:source]
              end
              @property.save
			end	
		end	
	end
end