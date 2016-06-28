class FuelsController < ApplicationController
  before_action :set_fuel, only: [:show, :edit, :update, :destroy]

  # GET /fuels
  # GET /fuels.json
  def index
    fuel = Fuel.all
    @fuels = current_user.fuel
  end

  # GET /fuels/1
  # GET /fuels/1.json
  def show
  end

  # GET /fuels/new
  def new
    @fuel = Fuel.new
  end

  # GET /fuels/1/edit
  def edit
    @fuel = Fuel.find(params[:id])
  end

  # POST /fuels
  # POST /fuels.json
  def create
    @fuel = Fuel.new(fuel_params)
    @fuel.user_id = current_user.id
    respond_to do |format|
      if @fuel.save
        #format.html { redirect_to @fuel, notice: 'Fuel was successfully created.' }
        #format.json { render :show, status: :created, location: @fuel }
        format.html { redirect_to vehicles_path(static_data:"static_fuel"), notice: 'Fuel was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @fuel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fuels/1
  # PATCH/PUT /fuels/1.json
  def update
    respond_to do |format|
      if @fuel.update(fuel_params)
        #format.html { redirect_to @fuel, notice: 'Fuel was successfully updated.' }
        #format.json { render :show, status: :ok, location: @fuel }
        format.html { redirect_to vehicles_path(static_data:"static_fuel"), notice: 'Fuel was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @fuel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fuels/1
  # DELETE /fuels/1.json
  def destroy
    @fuel.destroy
    respond_to do |format|
      format.html { redirect_to vehicles_path(static_data:"static_fuel"), notice: 'Fuel was successfully destroyed.' }
      #format.html { redirect_to fuels_url, notice: 'Fuel was successfully destroyed.' }
      #format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fuel
      @fuel = Fuel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fuel_params
      params.require(:fuel).permit(:user_id, :vehicle_id, :date, :odometer, :mark_as_void, :price, :fuel_type, :vandor_name, :reference, :mark_as_expense, :partial_fuel_up, :comment)
    end
end
