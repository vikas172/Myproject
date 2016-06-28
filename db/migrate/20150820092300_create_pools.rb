class CreatePools < ActiveRecord::Migration
  def change
    create_table :pools do |t|
      t.integer :property_id

      t.timestamps
    end
  end
end
