class Api::V1::InventoriesController < Api::V1::ApiController
	skip_before_filter  :verify_authenticity_token
  
  def index
		if current_user
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					inventories= Inventory.where(:user_id=> user_type_id)
				else
					inventories= Inventory.where(:user_id=> current_user.id)
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
					inventory = Inventory.new(inventory_params)
					inventory.user_id = user_type_id
				else
					inventory = Inventory.new(inventory_params)
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

  def show
  	if current_user
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					inventory = Inventory.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					inventory = Inventory.where(:user_id=>current_user.id ,:id=>params[:id]).first
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
  			inventory=Inventory.find(params[:id])
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

  def inventory_params
    params.require(:inventory).permit(:barcode, :barcode_type, :sku, :product_name, :brand, :description, :notes, :price, :price_wholesale, :price_sale, :currency, :shipping_weight, :shipping_unit, :quantity)
  end

  def current_user
  	User.find(params[:user_id])
  end
end
