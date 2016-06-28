class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
    @parts = Part.all
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Items")
    @custom_field_data=@item.custom_field if !@item.custom_field.blank?
  end

  # GET /items/new
  def new
    @item = Item.new
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Items")
  end

  # GET /items/1/edit
  def edit
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Items")
    @custom_field_data=@item.custom_field if !@item.custom_field.blank?
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
    @item.image=params[:item][:image]
    @item.user_id=current_user.id
    @item.custom_field=params[:custom_field]
    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    @item.image=params[:item][:image] if params[:item][:image]
    @item.custom_field=params[:custom_field]
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

#Inventory head display
  def inventory_head
    @item_head= current_user.item_head
    @part_head = current_user.part_head
  end

#Inventory head update 
  def inventory_update
    current_user.item_head = params[:item_head]
    current_user.part_head = params[:part_head]
    current_user.save
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :description, :product_model_number, :vendor_part_number, :vendor_name, :quantity, :unit_value, :value, :vendor_url, :category, :location,:l_name, :l_description, :l_product_model, :l_vendor_part, :l_vendor_name, :l_quantity, :l_unit, :l_value, :l_vendor_url, :l_category, :l_location,:l_image)
    end
end
