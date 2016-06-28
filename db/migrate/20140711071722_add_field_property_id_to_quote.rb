class AddFieldPropertyIdToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :property_id, :integer
  end
end
