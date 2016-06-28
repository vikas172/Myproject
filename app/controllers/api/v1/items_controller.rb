class Api::V1::ItemsController < Api::V1::ApiController
	skip_before_filter  :verify_authenticity_token
  
  def index
		if current_user
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					inventories= Item.where(:user_id=> user_type_id)
				else
					inventories= Item.where(:user_id=> current_user.id)
				end
				if inventories.blank?
				  render :status=>200, :json=>{:status => "Inventory not present"}
				else
					render :status=>200, :json=>inventories.as_json
				end
			else
				render :json=>{:status => "Failure match not found"}
			end	
		else
			render  :json=>{:status => "Failure Please login" }	
		end		
  end

  def new
  end

  def create
		if current_user
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					inventory = Item.new(item_params)
					inventory.user_id = user_type_id
				else
					inventory = Item.new(item_params)
					inventory.user_id = current_user.id
				end
				if inventory.save
					render :status=>200, :json=>inventory.as_json
				else
					render  :json=>{:status => "something went wrong please try again" }	
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
						inventory = Item.where(:user_id=>user_type_id,:id=>params[:id]).first
					else
						inventory = Item.where(:user_id=>current_user.id ,:id=>params[:id]).first
					end
					if inventory
						render :status=>200, :json=>inventory.as_json
					else
						render :status=>200, :json=>{:status => "Inventory not found"}
					end
				else
					render :json=>{:status => "Failure match not found"}
				end	
			else
				render :json=>{:status => "Failure Please login"}
			end
		end


	def update_item
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					inventory = Item.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					inventory = Item.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if inventory.update(item_params)
					render :status=>200, :json=>inventory.as_json
				else
					render :status=>200, :json=>{:status => "Inventory failure occur"}
				end
			else
				render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end


  def show
  	if current_user
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					inventory = Item.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					inventory = Item.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if inventory.blank?
					render :status=>200, :json=>{:status => "Inventory not present"}
				else
					render :status=>200, :json=>inventory.as_json
				end
			else
			  render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
  end

  def destroy
  	if current_user
  		if current_user.id == params[:user_id].to_i
  			inventory=Item.find(params[:id])
  			if inventory
  				inventory.destroy
  				render :status=>200, :json=>{:status => "Inventory deleted sucessfully"}
  			else
  				render :status=>200, :json=>{:status => "Inventory not present"}
  			end
  		else
  			render :json=>{:status => "Failure match not found"}
  		end
  	else
			render :json=>{:status => "Failure Please login"}
  	end
  end

  private

    def item_params
      params.require(:item).permit(:name, :description, :product_model_number, :vendor_part_number, :vendor_name, :quantity, :unit_value, :value, :vendor_url, :category, :location,:l_name, :l_description, :l_product_model, :l_vendor_part, :l_vendor_name, :l_quantity, :l_unit, :l_value, :l_vendor_url, :l_category, :l_location,:l_image)
    end

  def current_user
  	User.find(params[:user_id])
  end
end
