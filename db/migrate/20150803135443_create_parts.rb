class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.string :item_code
      t.text :description
      t.float :sales_price
      t.string :sales_code
      t.float :purchase_price
      t.string :purchase_code
      t.float :profit
      t.string :margin

      t.timestamps
    end
  end
end
