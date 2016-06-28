class CreateNumbers < ActiveRecord::Migration
  def change
    create_table :numbers do |t|
      t.string :account_sid
      t.string :auth_token
      t.string :phone_number
      t.string :phone_sid
      t.integer :user_id

      t.timestamps
    end
  end
end
