class AddFieldInvoiceJobToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :jobs_id, :string
  end
end
