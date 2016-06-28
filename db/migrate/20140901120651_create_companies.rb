class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :company_name
      t.string :company_phone
      t.string :company_email
      t.string :company_website
      t.text :company_address
      t.boolean :company_logo_show
      t.integer :user_id

      t.timestamps
    end
  end
end
