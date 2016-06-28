class AddFieldToPropertyIdToPoolData < ActiveRecord::Migration
  def change
    add_column :pool_data, :property_id, :integer
  end
end
