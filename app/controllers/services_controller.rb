class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /services
  # GET /services.json
  def index
    services = Service.all
    @services = current_user.services
  end

  # GET /services/1
  # GET /services/1.json
  def show
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
    @service = Service.find(params[:id])
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(service_params)
    @service.user_id = current_user.id
    respond_to do |format|
      if @service.save
        #format.html { redirect_to @service, notice: 'Service was successfully created.' }
        #format.json { render :show, status: :created, location: @service }
        format.html { redirect_to vehicles_path(static_data:"static_service"), notice: 'Service was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
        #format.html { redirect_to @service, notice: 'Service was successfully updated.' }
        #format.json { render :show, status: :ok, location: @service }
        format.html { redirect_to vehicles_path(static_data:"static_service"), notice: 'Service was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    respond_to do |format|
      #format.html { redirect_to services_url, notice: 'Service was successfully destroyed.' }
      #format.json { head :no_content }
      format.html { redirect_to vehicles_path(static_data:"static_service"), notice: 'Service was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params.require(:service).permit(:service_image, :user_id, :date, :vehicle_id, :odometer, :mark_as_void, :services_completed, :vendor, :reference, :comment, :labor, :parts, :tax, :total)
    end
end
