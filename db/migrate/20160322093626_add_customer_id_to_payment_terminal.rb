class AddCustomerIdToPaymentTerminal < ActiveRecord::Migration
  def change
    add_column :payment_terminals, :customer_id, :string
  end
end
