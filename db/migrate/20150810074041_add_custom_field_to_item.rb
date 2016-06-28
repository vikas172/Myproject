class AddCustomFieldToItem < ActiveRecord::Migration
  def change
    add_column :items, :custom_field, :text
    add_column :parts, :custom_field, :text
  end
end
