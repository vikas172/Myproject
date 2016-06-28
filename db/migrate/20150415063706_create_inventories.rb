class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.string :barcode
      t.string :barcode_type
      t.string :sku
      t.string :product_name
      t.string :brand
      t.text :description
      t.text :notes
      t.float :price
      t.float :price_wholesale
      t.float :price_sale
      t.string :currency
      t.float :shipping_weight
      t.float :shipping_unit
      t.integer :quantity
      t.integer :user_id
      t.timestamps
    end
  end
end
