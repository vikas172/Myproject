class CreateFuels < ActiveRecord::Migration
  def change
    create_table :fuels do |t|
      t.integer :vehicle_id
      t.string :date
      t.string :odometer
      t.boolean :mark_as_void
      t.float :price
      t.string :fuel_type
      t.string :vandor_name
      t.string :reference
      t.boolean :mark_as_expense
      t.boolean :partial_fuel_up
      t.text :comment

      t.timestamps
    end
  end
end
