class AddFieldsToFeeback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :scheduling, :boolean
    add_column :feedbacks, :submenu, :boolean
    add_column :feedbacks, :api, :boolean
    add_column :feedbacks, :analytics, :boolean
  end
end
