class CreateQuoteWorks < ActiveRecord::Migration
  def change
    create_table :quote_works do |t|
      t.string :name
      t.string :description
      t.string :quantity
      t.string :unit_cost
      t.string :total

      t.timestamps
    end
  end
end
