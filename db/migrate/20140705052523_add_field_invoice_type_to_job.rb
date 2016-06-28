class AddFieldInvoiceTypeToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :number_of_invoice, :integer
    add_column :jobs, :invoice_type, :string
  end
end
