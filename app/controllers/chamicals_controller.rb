class ChamicalsController < ApplicationController
	before_action :authenticate_user!

#List of chamicals	
	def index 
		@chamicals = current_user.chamicals
		@chamicals = @chamicals.order(params[:order_by]+' DESC') unless params[:order_by].blank?
		@clients = current_user.clients
		@chemical_setting = current_user.chemical_treatment_settings
	end

#New chamical object
	def new
		@chemical_treatment_setting = ChemicalTreatmentSetting.find_by_user_id(current_user.id)
		@chemical_treatment_mixtures = current_user.chemical_treatment_mixtures
		@property = Property.find(params[:property_id])
		@jobs = @property.jobs
		@client = @property.client
		@chamical = Chamical.new
	end

#Chamical show view
	def show
		@chemical = Chamical.find(params[:id])
		@property = Property.find(@chemical.property_id)
		@client = @property.client
		@jobs = @property.jobs
		@job_info = @jobs.find(@chemical.work_order_id) unless @chemical.work_order_id.blank?
		@applicator = User.find(@chemical.applicator_id).full_name unless @chemical.applicator_id.blank?
	end

#Chamical create 
	def create
		@chamical = Chamical.new(chamical_params)
		if @chamical.save
			redirect_to @chamical
		end
	end

#Chamical edit
	def edit
		@chamical = Chamical.find(params[:id])
		@property = Property.find(@chamical.property_id)
		@client = @property.client
	end

#Chamical update
	def update
		@chamical = Chamical.find(params[:id])
		@chamical.update(chamical_params)
		@property = Property.find(@chamical.property_id)
		@client = @property.client
		redirect_to @chamical
	end

#Chamical destroy
	def destroy
		@chamical = Chamical.find(params[:id])
		@chamical.destroy
		redirect_to chamicals_path
	end

	#chamical treatment setting 
	def chemical_treatment_setting
		@chemical_treatment_setting = ChemicalTreatmentSetting.find_by_user_id(current_user.id)
		@chemical_treatment_setting = ChemicalTreatmentSetting.new if @chemical_treatment_setting.blank?
		@chemical_treatment_mixtures = current_user.chemical_treatment_mixtures
	end

#chamical create setting
	def create_setting
		@chemical_treatment_setting = ChemicalTreatmentSetting.find_by_user_id(current_user.id)
		unless @chemical_treatment_setting.blank?
			@chemical_treatment_setting.chemicals = params[:chemical_treatment_settings][:chemicals]
			@chemical_treatment_setting.users_attributes = params[:chemical_treatment_settings][:users_attributes]
			@chemical_treatment_setting.update(chemical_treatment_setting_params)
		end
		ChemicalTreatmentSetting.create(chemical_treatment_setting_params) if @chemical_treatment_setting.blank?
		redirect_to :back
	end

#Chamical treatment mixture 
	def chemical_treatment_mixture
		@chemical_treatment_setting = ChemicalTreatmentSetting.find_by_user_id(current_user.id)
		@chemical_treatment_mixture = ChemicalTreatmentMixture.new
		@chemicals = current_user.chemical_treatment_settings.pluck(:chemicals)
	end

#Create mixture
	def create_mixture
		@create_mixture = ChemicalTreatmentMixture.create(chemical_treatment_mixture_params)
		redirect_to chemical_treatment_setting_path
	end

#Edit mixture
	def edit_chemical_treatment_mixture
		@chemical_treatment_setting = ChemicalTreatmentSetting.find_by_user_id(current_user.id)
		@chemical_treatment_mixture = ChemicalTreatmentMixture.find(params[:id])
	end

#Upadate mixture
	def update_mixture
		@chemical_treatment_mixture = ChemicalTreatmentMixture.find(params[:id])
		@chemical_treatment_mixture.update(chemical_treatment_mixture_params)
		redirect_to chemical_treatment_setting_path
	end

#Search client on list
	def search_client
    params[:q]=params[:q].gsub(/\s+/, "")
    @clients=current_user.clients.where('LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(company_name) LIKE ?', "#{params[:q].downcase}%","#{params[:q].downcase}%","#{params[:q].downcase}%")
	end

# Select property chemical
	def select_property_chemical
    @client=Client.find(params[:client_id])
    @client_properties=@client.properties
    redirect_to new_property_path(client_id: params[:client_id]) if @client_properties.count == 0
    redirect_to new_chamical_path(property_id: @client_properties.first.id) if @client_properties.count == 1
	end

	private
		def chamical_params
			params.require(:chamical).permit(:property_id, :work_order_id, :applicator_id, :date, :start_time, :end_time, :mixture_short_name, :chemicals, :targeted_pest, :total_applied, :total_area_of_application, :application_rate, :wind_direction, :wind_velocity, :temperature, :apparatus_info, :notes, :user_id)
		end

		def chemical_treatment_setting_params
			params.require(:chemical_treatment_setting).permit(:company_license_no, :users_attributes, :chemicals, :user_id)
		end

		def chemical_treatment_mixture_params
			params.require(:chemical_treatment_mixture).permit(:name, :targeted_pest, :chemicals, :user_id, :chemical_treatment_setting_id)
		end
end