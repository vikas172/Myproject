class AddFieldUserToPermission < ActiveRecord::Migration
  def change
    add_column :permissions, :user_id, :integer
  end
end
