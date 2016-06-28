class CreateMarketSources < ActiveRecord::Migration
  def change
    create_table :market_sources do |t|
    	t.string :source_name
    	t.integer :user_id

      t.timestamps
    end
  end
end
