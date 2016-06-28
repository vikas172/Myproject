class AddQuoteRateToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :raty_score, :integer
  end
end
