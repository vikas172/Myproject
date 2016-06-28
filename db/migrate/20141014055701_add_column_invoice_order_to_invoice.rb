class AddColumnInvoiceOrderToInvoice < ActiveRecord::Migration
  def change
  	add_column :invoices, :invoice_order, :integer,:default=> 0
  end
end
