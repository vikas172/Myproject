class AddColumnDataTypeToInvoice < ActiveRecord::Migration
  def change
  	change_column :invoices, :custom_field, :text
  end
end
