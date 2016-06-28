class AddActionTypeIdToKeys < ActiveRecord::Migration
  def change
    add_column :keys, :action_type_id, :integer
  end
end
