class CreateServiceItems < ActiveRecord::Migration
  def change
    create_table :service_items do |t|
    	t.boolean :filter_cleaned
    	t.boolean :netted_surface_debris 
    	t.boolean :brushed_walls_steps
    	t.boolean :cleaned_skimmer_baskets
    	t.boolean :cleaned_pump_basket
    	t.boolean :vacuumed_pool
    	t.boolean :checked_water_level
    	t.boolean :inspected_pump
    	t.text :notes_to_customer
    	t.integer :user_id
    	t.integer :property_id
      t.timestamps
    end
  end
end
