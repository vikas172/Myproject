class CreatePaymentInvoices < ActiveRecord::Migration
  def change
    create_table :payment_invoices do |t|
      t.float :pay_amount
      t.date :entry_date
      t.string :pay_method
      t.string :cheque_number
      t.string :transaction_number
      t.string :confirmation_number
      t.text :additional_note
      t.integer :user_id
      t.integer :invoice_id

      t.timestamps
    end
  end
end
