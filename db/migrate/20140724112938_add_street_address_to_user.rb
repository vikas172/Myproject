class AddStreetAddressToUser < ActiveRecord::Migration
  def change
    add_column :users, :street_address, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zip_code , :string
    add_column :users, :ssn, :string
    add_column :users, :start_date, :datetime
  end
end
