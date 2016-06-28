class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :payment
      t.text :subject
      t.date :issued_date
      t.float :tax
      t.float :discount_amount
      t.string :discount_type
      t.float :deposite_amount
      t.date :entry_date
      t.string :payment_method_type
      t.string :payment_method
      t.text :additional_note
      t.text :client_message

      t.timestamps
    end
  end
end
