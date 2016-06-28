class AddFieldToPermission < ActiveRecord::Migration
  def change
    add_column :permissions, :team_member_id, :integer
  end
end
