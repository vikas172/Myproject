class CreateInvoiceWorks < ActiveRecord::Migration
  def change
    create_table :invoice_works do |t|
      t.string :name
      t.text :description
      t.string :quantity
      t.string :unit_cost
      t.string :total

      t.timestamps
    end
  end
end
