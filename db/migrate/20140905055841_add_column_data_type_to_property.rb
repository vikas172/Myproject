class AddColumnDataTypeToProperty < ActiveRecord::Migration
  def change
  	change_column :properties, :custom_field, :text
  end
end
