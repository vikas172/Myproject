class AddLastNameToTeamMembers < ActiveRecord::Migration
  def change
    add_column :team_members, :last_name, :string
  end
end
