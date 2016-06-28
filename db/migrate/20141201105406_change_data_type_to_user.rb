class ChangeDataTypeToUser < ActiveRecord::Migration
  def change
  	rename_column :users, :street_address, :street
  	rename_column :users, :zip_code, :zipcode
  end
end
