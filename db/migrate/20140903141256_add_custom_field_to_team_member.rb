class AddCustomFieldToTeamMember < ActiveRecord::Migration
  def change
    add_column :team_members, :custom_field, :text
  end
end
