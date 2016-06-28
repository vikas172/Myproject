class AddQIdToQuoteWork < ActiveRecord::Migration
  def change
    add_column :quote_works, :quote_id, :integer
  end
end
