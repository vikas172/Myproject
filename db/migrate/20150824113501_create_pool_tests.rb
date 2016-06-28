class CreatePoolTests < ActiveRecord::Migration
  def change
    create_table :pool_tests do |t|
      t.string :chlorine
      t.string :ph_value
      t.string :salt_level
      t.string :total_alkalinity
      t.string :calcium_hardness
      t.string :source
      t.string :date
      t.integer :property_id
      t.integer :user_id
      t.timestamps
    end
  end
end
