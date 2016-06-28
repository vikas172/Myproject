class CreatePropertyCalls < ActiveRecord::Migration
  def change
    create_table :property_calls do |t|
      t.string :from
      t.string :to
      t.integer :user_id
      t.integer :property_id

      t.timestamps
    end
  end
end
