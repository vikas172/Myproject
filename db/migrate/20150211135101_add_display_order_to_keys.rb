class AddDisplayOrderToKeys < ActiveRecord::Migration
  def change
    add_column :keys, :display_order, :integer
  end
end
