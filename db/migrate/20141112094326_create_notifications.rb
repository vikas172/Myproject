class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :client_id
      t.integer :user_id
      t.string :notification_day
      t.time :notification_time
      t.string :team_mobile_number
      t.string :team_notification_by
      t.string :team_notification_preference
      t.string :client_mobile_number
      t.string :client_notification_by
      t.string :client_notification_preference
      t.timestamps
    end
  end
end
