class AddFieldToVendorSetting < ActiveRecord::Migration
  def change
    add_column :vendor_settings, :prefer_marker, :string
  end
end
