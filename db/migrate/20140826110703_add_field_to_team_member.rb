class AddFieldToTeamMember < ActiveRecord::Migration
  def change
    add_column :team_members, :full_name, :string
    add_column :team_members, :email, :string
    add_column :team_members, :phone_number, :string
    add_column :team_members, :street_address, :string
    add_column :team_members, :city, :string
    add_column :team_members, :state, :string
    add_column :team_members, :zip_code, :string
    add_column :team_members, :ssn_number, :string
    add_column :team_members, :start_date, :date
  end
end
