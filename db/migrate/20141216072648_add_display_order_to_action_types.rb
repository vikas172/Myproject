class AddDisplayOrderToActionTypes < ActiveRecord::Migration
  def change
    add_column :action_types, :display_order, :integer
  end
end
