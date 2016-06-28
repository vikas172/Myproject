class AddAdminFieldToTeamMember < ActiveRecord::Migration
  def change
    add_column :team_members, :is_admin, :boolean, default: false
  end
end
