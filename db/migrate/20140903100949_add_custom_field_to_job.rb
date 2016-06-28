class AddCustomFieldToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :custom_field, :string
  end
end
