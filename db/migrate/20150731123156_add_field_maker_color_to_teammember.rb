class AddFieldMakerColorToTeammember < ActiveRecord::Migration
  def change
    add_column :team_members, :marker_color, :string
  end
end
