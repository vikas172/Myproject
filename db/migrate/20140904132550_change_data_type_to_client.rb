class ChangeDataTypeToClient < ActiveRecord::Migration
  def change
  	change_column :clients, :custom_field, :text
  end
end
