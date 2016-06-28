class CreatePoolData < ActiveRecord::Migration
  def change
    create_table :pool_data do |t|
    	t.string :pool_type
    	t.string :pool_shape
    	t.string :pool_size
    	t.string :pool_gallonage
    	t.string :equip_pump_brand
    	t.string :equip_model
    	t.string :equip_horsepower
    	t.string :equip_service_factor
    	t.string :equip_voltage
    	t.string :filter_brand
    	t.string :filter_model
    	t.string :filter_type
    	t.string :filter_cartridge
    	t.string :filter_date_replaced
    	t.string :filter_de
    	t.string :heater_brand
    	t.string :heater_model
    	t.string :heater_size
    	t.string :heater_type
    	t.string :time_clock_brand
    	t.string :time_clock_model
    	t.string :time_clock_voltage
      t.timestamps
    end
  end
end
