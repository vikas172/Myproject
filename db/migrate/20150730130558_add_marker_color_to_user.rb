class AddMarkerColorToUser < ActiveRecord::Migration
  def change
    add_column :users, :marker_color, :string
  end
end
