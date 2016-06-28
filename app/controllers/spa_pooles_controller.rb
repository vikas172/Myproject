class SpaPoolesController < ApplicationController
  include SpaPoolesHelper

#pool new object initial  
	def property_pool_data
    @pool_data=PoolData.new
  end

#pool data create
  def pool_data_create
    @pool_data=PoolData.new(pool_params)
    @pool_data.save
    redirect_to :back
  end

#pool data edit
  def pool_data_edit
    @property = Property.find(params[:property_id]) if !params[:property_id].blank?
    @pool_data = @property.pool_data  if  !@property.pool_data.blank?
  end

#pool data update
  def pool_data_update
   @pool=PoolData.find(params[:pool_id])
   @pool.update(pool_params)
   @pool.pool_gallonage = @pool.property.pool_volume if !@pool.property.blank?
   @pool.save if !@pool.property.blank?
   redirect_to :back
  end

#spa data object initial
  def spa_data
  	@spa_data= SpaData.new
  end

#spa data object create
  def spa_data_create
  	@spa_data=SpaData.new(spa_params)
    @spa_data.save
    redirect_to :back
  end

#spa data edit 
  def spa_data_edit
  	@property = Property.find(params[:property_id]) if !params[:property_id].blank?
    @spa_data = @property.spa_data  if  !@property.spa_data.blank?
  end

#spa data update
  def spa_data_update
  	@spa=SpaData.find(params[:spa_id])
   	@spa.update(spa_params)
    @spa.spa_gallonage = @spa.property.pool_volume2 if !@spa.property.blank?
    @spa.save if !@spa.property.blank?
   	redirect_to :back
  end

#calulate gallonage values
  def calculate_gallonage
    @property = Property.find(params[:property_id]) if !params[:property_id].blank?
    @pool_data=@property.pool_data
    if !@property.blank?
      @poll_value = get_pool_volume(params,@property)
      if @poll_value != 0.0
        @pool_data.pool_gallonage = @poll_value.round(2) if !@pool_data.blank?
        @pool_data.save if !@pool_data.blank?
        @property.pool_volume = @poll_value.round(2)
        @property.save
      end
    end
  end

# calulate spa volumne
  def calculate_spa_volume
    @property = Property.find(params[:property_id]) if !params[:property_id].blank?
    @spa_data=@property.spa_data
    if !@property.blank?
      @spa_value = get_spa_volume(params,@property)
      if @spa_value != 0.0
        @spa_data.spa_gallonage = @spa_value.round(2) if !@spa_data.blank?
        @spa_data.save if !@spa_data.blank?
        @property.pool_volume2 = @spa_value.round(2)
        @property.save
      end
    end
  end

  def pool_shape_change
  end
  
  def spa_shape_change
  end

  private 
    def pool_params
      params.require(:pool_data).permit(:pool_type,:pool_shape,:pool_size,:pool_gallonage,:equip_pump_brand,:equip_model,:equip_horsepower,:equip_service_factor,:equip_voltage,:filter_brand,:filter_model,:filter_type,:filter_cartridge,:filter_date_replaced,:filter_de,:heater_brand,:heater_model,:heater_size,:heater_type,:time_clock_brand,:time_clock_model,:time_clock_voltage,:property_id,:depth,:depth2,:width,:width2,:length,:diameter)
    end

    def spa_params
    	params.require(:spa_data).permit(:spa_type,:type_manufacturer,:type_model,:type_serial_number,:equip_pump_brand,:type_color,:type_voltage,:spa_shape,:spa_size,:spa_gallonage,:surface_material,:surface_material,:equip_model,:equip_horsepower,:equip_service_factor,:equip_voltage,:filter_brand,:filter_model,:filter_type,:cartridge_size,:cartridge_part,:cartridge_date,:filter_sand_model,:filter_sand_size,:filter_de,:heater_brand,:heater_model,:heater_type,:time_clock_brand,:time_clock_model,:time_clock_voltage,:property_id,:depth,:depth2,:width,:width2,:length,:diameter)
    end
end
