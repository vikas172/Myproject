class AddColumnToPaymentInvoice < ActiveRecord::Migration
  def change
  	add_column :payment_invoices, :transaction_type, :string
    add_column :payment_invoices, :client_id, :integer
  end
end
