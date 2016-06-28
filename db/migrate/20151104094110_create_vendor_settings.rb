class CreateVendorSettings < ActiveRecord::Migration
  def change
    create_table :vendor_settings do |t|
      t.string :vendor_type
      t.string :vendor_miles
      t.text :preference_vendor
      t.integer :user_id

      t.timestamps
    end
  end
end
