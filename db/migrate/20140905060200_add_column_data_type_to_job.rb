class AddColumnDataTypeToJob < ActiveRecord::Migration
  def change
  	change_column :jobs, :custom_field, :text
  end
end
