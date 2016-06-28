class AddLabelFieldToItem < ActiveRecord::Migration
  def change
    add_column :items, :l_name, :string
    add_column :items, :l_description, :string
    add_column :items, :l_product_model, :string
    add_column :items, :l_vendor_part, :string
    add_column :items, :l_vendor_name, :string
    add_column :items, :l_quantity, :string
    add_column :items, :l_unit, :string
    add_column :items, :l_value, :string
    add_column :items, :l_vendor_url, :string
    add_column :items, :l_category, :string
    add_column :items, :l_location, :string
    add_column :items, :l_image, :string
  end
end
