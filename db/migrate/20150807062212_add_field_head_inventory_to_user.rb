class AddFieldHeadInventoryToUser < ActiveRecord::Migration
  def change
    add_column :users, :item_head, :string
    add_column :users, :part_head, :string
  end
end
