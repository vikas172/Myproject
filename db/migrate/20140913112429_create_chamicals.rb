class CreateChamicals < ActiveRecord::Migration
  def change
    create_table :chamicals do |t|
			t.integer  :property_id
			t.integer  :work_order_id
			t.integer  :applicator_id
			t.date     :date
			t.time     :start_time
			t.time     :end_time
			t.string   :mixture_short_name
			t.string   :chemicals
			t.string   :chemicals
			t.string   :targeted_pest
			t.string   :total_applied
			t.string   :total_area_of_application
			t.string   :application_rate
			t.string   :wind_direction
			t.string   :wind_velocity
			t.string   :temperature
			t.text 	   :apparatus_info
			t.text 	   :notes
      t.timestamps
    end
  end
end
