class AddNotificationFieldToTeamMember < ActiveRecord::Migration
  def change
    add_column :team_members, :mobile_number, :string
    add_column :team_members, :preference, :string
  end
end
