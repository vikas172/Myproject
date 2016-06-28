class CreateServiceReminders < ActiveRecord::Migration
  def change
    create_table :service_reminders do |t|
      t.string :vehicle_name
      t.string :service_task
      t.string :meter_interval
      t.float :time_interval
      t.string :time_duration
      t.float :meter_threshold
      t.float :time_threshold
      t.string :threshold_duration
      t.boolean :email_notification
      t.string :subscribed_user

      t.timestamps
    end
  end
end
