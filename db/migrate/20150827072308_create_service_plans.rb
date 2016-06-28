class CreateServicePlans < ActiveRecord::Migration
  def change
    create_table :service_plans do |t|
    	t.string :name
    	t.text   :description 
    	t.float  :unit_cost
    	t.integer :property_id
      t.integer :user_id
      t.timestamps
    end
  end
end
