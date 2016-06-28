class AddSentFieldToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :mark_sent, :boolean, default: false
    add_column :invoices, :invoice_paid, :boolean, default: false
    add_column :invoices, :invoice_bad_debt, :boolean, default: false
  end
end
