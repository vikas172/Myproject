class AddCustomFieldToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :custom_field, :string
  end
end
