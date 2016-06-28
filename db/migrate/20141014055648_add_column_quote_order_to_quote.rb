class AddColumnQuoteOrderToQuote < ActiveRecord::Migration
  def change
  	add_column :quotes, :quote_order, :integer,:default=> 0
  end
end
