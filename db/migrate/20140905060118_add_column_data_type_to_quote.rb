class AddColumnDataTypeToQuote < ActiveRecord::Migration
  def change
  	change_column :quotes, :custom_field, :text
  end
end
