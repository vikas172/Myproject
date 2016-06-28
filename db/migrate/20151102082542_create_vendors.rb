class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :vendor_type
      t.string :name
      t.string :location_name
      t.string :street
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :phone
      t.string :fax
      t.string :source
      t.integer :user_id

      t.timestamps
    end
  end
end
