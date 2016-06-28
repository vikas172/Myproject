class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.float :tax
      t.float :discount
      t.string :discount_type
      t.float :require_deposit
      t.string :require_deposit_type
      t.text :client_message

      t.timestamps
    end
  end
end
