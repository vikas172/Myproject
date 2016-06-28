class CreatePhoneNumbers < ActiveRecord::Migration
  def change
    create_table :phone_numbers do |t|
      t.string :phone_number
      t.string :pin
      t.boolean :verified
      t.integer :user_id

      t.timestamps
    end
  end
end
