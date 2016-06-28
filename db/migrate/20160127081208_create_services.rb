class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :date
      t.integer :vehicle_id
      t.string :odometer
      t.boolean :mark_as_void
      t.string :services_completed
      t.string :vendor
      t.string :reference
      t.text :comment
      t.float :labor
      t.float :parts
      t.float :tax
      t.float :total

      t.timestamps
    end
  end
end
