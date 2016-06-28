class ClassifiedsController < ApplicationController
  before_action :set_classified, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # load_and_authorize_resource
  # GET /classifieds
  # GET /classifieds.json
  def index
    @classifieds = Classified.all
  end

  # GET /classifieds/1
  # GET /classifieds/1.json
  def show
    geocode= "#{@classified.try(:street)},#{@classified.try(:city)},#{@classified.try(:state)},#{@classified.try(:zipcode)}"
    @gecode=Geocoder.search(geocode)
  end

  # GET /classifieds/new
  def new
    @classified = Classified.new
  end

  # GET /classifieds/1/edit
  def edit
  end

  # POST /classifieds
  # POST /classifieds.json
  def create
    @classified = Classified.new(classified_params)
    @classified.user_id= current_user.id 
    respond_to do |format|
      if @classified.save
        format.html { redirect_to media_classified_path(:id=>@classified.id), notice: 'Classified was successfully created.' }
        format.json { render :show, status: :created, location: @classified }
      else
        format.html { render :new }
        format.json { render json: @classified.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /classifieds/1
  # PATCH/PUT /classifieds/1.json
  def update
    respond_to do |format|
      if @classified.update(classified_params)
        format.html { redirect_to @classified, notice: 'Classified was successfully updated.' }
        format.json { render :show, status: :ok, location: @classified }
      else
        format.html { render :edit }
        format.json { render json: @classified.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /classifieds/1
  # DELETE /classifieds/1.json
  def destroy
    @classified.destroy
    respond_to do |format|
      format.html { redirect_to classifieds_url, notice: 'Classified was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

#Classifieds get and upload media
  def media  
    @classified=Classified.find(params[:id])
  end
  
#Classifieds media save
  def media_save
    @classified=Classified.find(params[:id])
    @classified.image=params["classified"][:image]
    @classified.save
    redirect_to @classified
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_classified
      @classified = Classified.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def classified_params
      params.require(:classified).permit(:privacy, :contact_phone, :contact_text, :phone_number, :contact_name, :posting_title, :specific_location, :postal_code, :posting_body,:license_info,:license ,:show_on_map, :street, :city, :state, :zipcode, :contact_ok)
    end
end