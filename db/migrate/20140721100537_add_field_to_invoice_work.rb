class AddFieldToInvoiceWork < ActiveRecord::Migration
  def change
    add_column :invoice_works, :invoice_id, :integer
  end
end
