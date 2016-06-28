class AddFieldPastDueToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :past_due, :boolean, default: false
  end
end
