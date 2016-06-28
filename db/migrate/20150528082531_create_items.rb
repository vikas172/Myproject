class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.text :product_model_number
      t.string :vendor_part_number
      t.string :vendor_name
      t.integer :quantity
      t.float :unit_value
      t.float :value
      t.string :vendor_url
      t.string :category
      t.string :location

      t.timestamps null: false
    end
  end
end
