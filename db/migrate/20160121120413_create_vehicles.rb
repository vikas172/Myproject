class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :vehicle_name
      t.string :vin_no
      t.string :vehicle_type
      t.string :year
      t.string :make
      t.string :model
      t.string :trim
      t.string :license_plate
      t.string :registation
      t.string :status
      t.string :group
      t.string :driver
      t.string :ownership
      t.string :color
      t.string :body_type
      t.string :body_subtype
      t.float :msrp

      t.timestamps
    end
  end
end
