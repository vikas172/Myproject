class AddStreetToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :street, :string
    add_column :companies, :city, :string
    add_column :companies, :state, :string
    add_column :companies, :zipcode, :string
  end
end
