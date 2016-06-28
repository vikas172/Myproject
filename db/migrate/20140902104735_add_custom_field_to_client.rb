class AddCustomFieldToClient < ActiveRecord::Migration
  def change
    add_column :clients, :custom_field, :string
  end
end
