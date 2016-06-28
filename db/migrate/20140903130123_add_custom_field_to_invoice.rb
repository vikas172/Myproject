class AddCustomFieldToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :custom_field, :string
  end
end
