class Api::V1::PropertiesController < Api::V1::ApiController
	skip_before_filter  :verify_authenticity_token
	
	def index
		if !current_user.blank?
			if current_user.user_type=="user"
				user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
				properties = Property.where(:user_id=>user_type_id)
			else
				properties = Property.where(:user_id=>current_user.id )
			end
			render :status=>200, :json=>properties.as_json
		else
			render  :json=>{:status => "Failure Please login" }
		end
	end
	

	def new
	end

	def create
		if !current_user.blank?	
			if current_user.user_type=="user"
				user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
				@user = User.find(user_type_id)
			else
				@user = current_user
			end
			property= Property.new(property_params)
		 	property.user_id = @user.id
			if property.save
				render :status=>200, :json=>property.as_json
			else
				render :json=>{:status => "property not save some failure occur"}
			end
		else
			render  :json=>{:status => "Failure Please login" }
		end
	end

	def show
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					property = Property.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					property = Property.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if property
					render :status=>200, :json=>property.as_json
				else
					render :status=>200, :json=>{:status => "Property not found"}
				end
			else
				render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	def edit
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					property = Property.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					property = Property.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if property
				  client =  property.client
				  customer_detail = {:customer_address=>get_client_address(client) ,:customer_email=> client.personal_email,:customer_mobile_number=>client.mobile_number,:first_name=>client.first_name,:last_name=>client.last_name}
				  render :status=>200, :json=>{:property_details=>property.as_json,:customer_detail=>customer_detail.as_json}
				else
					render :status=>200, :json=>{:status => "Client not found"}
				end
			else
				render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	def get_client_address(client)
		if client.street1.blank?
			return ""
		else
			return "#{client.street1}, #{client.city} , #{client.state},#{client.zip_code}"
		end
	end

	def update_property
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					property = Property.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					property = Property.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if property.update(property_params)
					render :status=>200, :json=>property.as_json
				else
					render :status=>200, :json=>{:status => "Property failure occur"}
				end
			else
				render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	def destroy
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					property = Property.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					property = Property.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if property
					property.destroy
					render :status=>200, :json=>{:status => "Property Deleted sucessfully"}
				else
					render :status=>200, :json=>{:status => "Property not found"}
				end
			else
			  render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	private
	def current_user
  	User.find(params[:user_id]) rescue ""
  end

  def property_params
    params.require(:property).permit(:street, :street2, :city, :state, :zipcode, :country,:user_id,:client_id)
  end

end