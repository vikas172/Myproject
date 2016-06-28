class CreatePaymentTerminals < ActiveRecord::Migration
  def change
    create_table :payment_terminals do |t|
      t.integer :client_id
      t.float :amount
      t.text :description
      t.string :payment_type
      t.string :name
      t.string :email
      t.string :street
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :country
      t.string :name_on_card
      t.string :card_number
      t.integer :exp_month
      t.integer :exp_year
      t.integer :cvc
      t.string :transaction_id

      t.timestamps
    end
  end
end
