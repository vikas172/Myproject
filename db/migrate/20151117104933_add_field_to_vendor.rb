class AddFieldToVendor < ActiveRecord::Migration
  def change
    add_column :vendors, :latitude, :float
    add_column :vendors, :longitude, :float
  end
end
