class Api::V1::ClientsController < Api::V1::ApiController
	skip_before_filter  :verify_authenticity_token
	def index
		if !current_user.blank?
			if current_user.user_type=="user"
				user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
				clients = Client.where(:user_id=>user_type_id)
			else
			  clients=current_user.clients
			end
			render :status=>200, :json=>clients.as_json
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
			client= Client.new(client_params)
		 	client.user_id = @user.id
			if client.save
				render :status=>200, :json=>client.as_json
			else
				render :json=>{:status => "Client not save some failure occur"}
			end
		else
			render  :json=>{:status => "Failure Please login" }
		end
	end

	def edit
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					client = Client.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					client = Client.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if client
					render :status=>200, :json=>client.as_json
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

	def update_client
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					client = Client.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					client = Client.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if client.update(client_params)
					render :status=>200, :json=>client.as_json
				else
					render :status=>200, :json=>{:status => "Client failure occur "}
				end
			else
				render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	def show
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					client = Client.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					client = Client.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if client
					render :status=>200, :json=>client.as_json
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

	def destroy
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					client = Client.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					client = Client.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if client
					client.destroy
					render :status=>200, :json=>{:status => "Client Deleted sucessfully"}
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

	def client_property
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				client=Client.find(params[:id])
				if client.blank?
					render :json=>{:status => "Client not found"}
				else
					properties = client.properties
					render :status=>200, :json=>properties.as_json
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

  def client_params
    params.require(:client).permit(:initial, :first_name, :last_name, :company_name, :primary_company, :street1, :street2, :city, :state, :zip_code, :country, :personal_email, :mobile_number ,:preference_notification,:phone_number,:email)
  end
end
