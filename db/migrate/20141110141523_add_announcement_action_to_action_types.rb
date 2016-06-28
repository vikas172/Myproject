class AddAnnouncementActionToActionTypes < ActiveRecord::Migration
  def change
    add_column :action_types, :announcement_action, :boolean
  end
end
