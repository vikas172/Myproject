class ChangeColumnDataTypeToClient < ActiveRecord::Migration
  def change
  	change_column :clients, :zip_code, :string
  end
end
