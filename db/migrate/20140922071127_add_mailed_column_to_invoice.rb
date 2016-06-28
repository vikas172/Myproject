class AddMailedColumnToInvoice < ActiveRecord::Migration
  def change
  	add_column :invoices, :is_mailed, :boolean, default: false
  end
end
