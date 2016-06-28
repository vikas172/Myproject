class ChangeColumnDataTypeToProperty < ActiveRecord::Migration
   def change
  	change_column :properties, :zip_code, :string
  end
end
