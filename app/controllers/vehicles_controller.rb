class VehiclesController < ApplicationController
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]

  # GET /vehicles
  # GET /vehicles.json
  def index
    @vehicles = current_user.vehicles
    @vehicle = Vehicle.new
    @fuels = current_user.fuels
    @services = current_user.services
    @service_reminders = current_user.service_reminders
  
  end

  # GET /vehicles/1
  # GET /vehicles/1.json
  def show
  end

  # GET /vehicles/new
  def new
    # edmunds = Edmunds::Make.new
    # edmunds.find_all
    @vehicle = Vehicle.new
  end

  # GET /vehicles/1/edit
  def edit
    @vehicle = Vehicle.find(params[:id])
  end

  # POST /vehicles
  # POST /vehicles.json
  def create
    @vehicle = Vehicle.new(vehicle_params)
    @vehicle.user_id = current_user.id
    respond_to do |format|
      if @vehicle.save
        #format.html { redirect_to @vehicle, notice: 'Vehicle was successfully created.' }
        #format.json { render :show, status: :created, location: @vehicle }
        format.html { redirect_to vehicles_path(static_data:"static_vehicle"), notice: 'Vehicle was successfully created.' }
        #format.json { render :show, status: :created, location: @vehicle }
      else
        format.html { render :new }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicles/1
  # PATCH/PUT /vehicles/1.json
  def update
    respond_to do |format|
      if @vehicle.update(vehicle_params)
        format.html { redirect_to vehicles_path(static_data:"static_vehicle"), notice: 'Vehicle was successfully updated.' }
        #format.html { redirect_to @vehicle, notice: 'Vehicle was successfully updated.' }
        #format.json { render :show, status: :ok, location: @vehicle }
      else
        format.html { render :edit }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicles/1
  # DELETE /vehicles/1.json
  def destroy
    @vehicle.destroy
    respond_to do |format|
    format.html { redirect_to vehicles_path(static_data:"static_vehicle"), notice: 'Vehicle was successfully destroyed.' }
    #format.html { redirect_to vehicles_url, notice: 'Vehicle was successfully destroyed.' }
    #format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vehicle_params
      params.require(:vehicle).permit(:vehicle_image, :user_id, :vehicle_name, :vin_no, :vehicle_type, :year, :make, :model, :trim, :license_plate, :registation, :status, :group, :driver, :ownership, :color, :body_type, :body_subtype, :msrp)
    end
end
