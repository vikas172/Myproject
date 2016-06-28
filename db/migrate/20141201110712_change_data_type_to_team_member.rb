class ChangeDataTypeToTeamMember < ActiveRecord::Migration
  def change
  	rename_column :team_members, :street_address, :street
  	rename_column :team_members, :zip_code, :zipcode
  end
end
