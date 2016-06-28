class CreateKeyDescriptions < ActiveRecord::Migration
  def change
    create_table :key_descriptions do |t|
      t.integer :key_number
      t.string :description
      t.integer :user_id

      t.timestamps
    end
  end
end
