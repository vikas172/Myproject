class ChangeColumnNameToProperty < ActiveRecord::Migration
  def change
  	rename_column :properties, :street1, :street
  	rename_column :properties, :zip_code, :zipcode
  end
end
