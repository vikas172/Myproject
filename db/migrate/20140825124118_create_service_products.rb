class CreateServiceProducts < ActiveRecord::Migration
  def change
    create_table :service_products do |t|
      t.string :item_type
      t.string :name
      t.text :description
      t.float :unit_cost
      t.boolean :non_taxable, default: false
      t.integer :user_id
      t.boolean :active

      t.timestamps
    end
  end
end
