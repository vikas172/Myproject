class CreateSpaData < ActiveRecord::Migration
  def change
    create_table :spa_data do |t|
    	t.string :spa_type
    	t.string :type_manufacturer
    	t.string :type_model
    	t.string :type_serial_number
    	t.string :type_color
    	t.string :type_voltage
    	t.string :spa_shape
    	t.string :spa_size
    	t.string :spa_gallonage
    	t.string :surface_material
    	t.string :equip_pump_brand
    	t.string :equip_model
    	t.string :equip_horsepower
    	t.string :equip_service_factor
    	t.string :equip_voltage
    	t.string :filter_brand
    	t.string :filter_model
    	t.string :filter_type
    	t.string :cartridge_size
    	t.string :cartridge_part
    	t.string :cartridge_date
    	t.string :filter_sand_model
    	t.string :filter_sand_size
    	t.string :filter_de
    	t.string :heater_brand
    	t.string :heater_model
    	t.string :heater_type
    	t.string :time_clock_brand
    	t.string :time_clock_model
    	t.string :time_clock_voltage
    	t.integer :property_id

      t.timestamps
    end
  end
end
