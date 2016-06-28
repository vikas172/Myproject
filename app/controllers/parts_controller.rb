class PartsController < ApplicationController

  before_action :set_part, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @parts = Part.all
    @items = Item.all
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Parts")
    @custom_field_data=@part.custom_field if !@part.custom_field.blank?
  end

  # GET /items/new
  def new
    @part = Part.new
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Parts")
  end

  # GET /items/1/edit
  def edit
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Parts")
    @custom_field_data=@part.custom_field if !@part.custom_field.blank?
  end

  # POST /items
  # POST /items.json
  def create
    @part = Part.new(part_params)
    @part.user_id=current_user.id
    @part.custom_field=params[:custom_field]
    respond_to do |format|
      if @part.save
        format.html { redirect_to @part, notice: 'Part was successfully created.' }
        format.json { render :show, status: :created, location: @part }
      else
        format.html { render :new }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    @part.custom_field=params[:custom_field]
    respond_to do |format|
      if @part.update(part_params)
        format.html { redirect_to @part, notice: 'Part was successfully updated.' }
        format.json { render :show, status: :ok, location: @part }
      else
        format.html { render :edit }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @part.destroy
    respond_to do |format|
      format.html { redirect_to parts_url, notice: 'Part was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_part
      @part = Part.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def part_params
      params.require(:part).permit(:item_code, :description, :sales_price, :sales_code, :purchase_price, :purchase_code, :profit, :margin,:l_item,:l_description,:l_s_price,:l_s_code,:l_p_price,:l_p_code,:l_profit,:l_margin)
    end
end


