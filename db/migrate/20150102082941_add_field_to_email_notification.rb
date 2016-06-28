class AddFieldToEmailNotification < ActiveRecord::Migration
  def change
    add_column :email_notifications, :is_read, :boolean, default: false
  end
end
