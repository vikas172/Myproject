class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.string :name
      t.string :card_number
      t.integer :exp_month
      t.integer :exp_year
      t.integer :cvc
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :country
      t.string :zip_code
      t.string :transaction_id
      t.string :email
      t.float :amount
      t.boolean :paid
      t.integer :user_id

      t.timestamps
    end
  end
end
