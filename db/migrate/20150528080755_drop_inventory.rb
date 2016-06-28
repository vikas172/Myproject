class DropInventory < ActiveRecord::Migration
  def change
  	drop_table :inventories
  end
end
