class AddCustomFieldToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :custom_field, :string
  end
end
