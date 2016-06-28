class AddMarketSourceToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :market_source, :string
  end
end
