class CreateServicePlanLabels < ActiveRecord::Migration
  def change
    create_table :service_plan_labels do |t|
	    t.string :filter_cleaned
	    t.string :backwash
	    t.string :brushed_walls_steps
	    t.string :skimming_surface
	    t.string :waterline_tiles_cleaned
	    t.string :cleaned_skimmer_baskets
	    t.string :netted_surface_debris
	    t.string :floor_vacuumed
	    t.string :pump_strainer_baskets
	    t.string :cleaned_pump_basket
	    t.string :vacuumed_pool
	    t.string :checked_water_level
	    t.string :inspected_pump
	    t.string :pool_sweep_cleaner
	    t.string :net_surface_bottom
	    t.string :inspect_pool_spa_eqip
	    t.string :wipe_ladder_handrails
	    t.string :add_water_needed
	    t.string :filter_pressure_monitor
	    t.string :adjust_timeclock
	    t.string :notes_to_customer
	    t.integer :user_id
	    t.timestamps
    end
  end
end
