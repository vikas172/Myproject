class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :initial
      t.string :first_name
      t.string :last_name
      t.string :company_name
      t.boolean :primary_company
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.integer :zip_code
      t.string :country
      t.string :phone_initial
      t.integer :phone_number,:limit=>8
      t.string :email_initial
      t.string :email

      t.timestamps
    end
  end
end
