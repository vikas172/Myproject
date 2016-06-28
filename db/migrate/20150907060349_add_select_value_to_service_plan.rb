class AddSelectValueToServicePlan < ActiveRecord::Migration
  def change
  	add_column :service_plans,:filter_cleaned,:boolean
  	add_column :service_plans,:backwash,:boolean
  	add_column :service_plans,:brushed_walls_steps,:boolean
  	add_column :service_plans,:skimming_surface,:boolean
  	add_column :service_plans,:waterline_tiles_cleaned,:boolean
  	add_column :service_plans,:cleaned_skimmer_baskets,:boolean
  	add_column :service_plans,:netted_surface_debris,:boolean
  	add_column :service_plans,:floor_vacuumed,:boolean
  	add_column :service_plans,:pump_strainer_baskets,:boolean
  	add_column :service_plans,:cleaned_pump_basket,:boolean
  	add_column :service_plans,:vacuumed_pool,:boolean
  	add_column :service_plans,:checked_water_level,:boolean
  	add_column :service_plans,:inspected_pump,:boolean
  	add_column :service_plans,:pool_sweep_cleaner,:boolean
  	add_column :service_plans,:net_surface_bottom,:boolean
  	add_column :service_plans,:inspect_pool_spa_eqip,:boolean
  	add_column :service_plans,:wipe_ladder_handrails,:boolean
  	add_column :service_plans,:add_water_needed,:boolean
  	add_column :service_plans,:filter_pressure_monitor,:boolean
  	add_column :service_plans ,:notes_to_customer,:boolean
    add_column :service_plans ,:adjust_timeclock,:boolean
    add_column :service_plans ,:status,:string
  	add_column :service_plans ,:customer_note,:text
  end
end
