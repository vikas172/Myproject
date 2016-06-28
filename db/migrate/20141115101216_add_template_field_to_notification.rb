class AddTemplateFieldToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :team_email, :text
    add_column :notifications, :team_sms, :text
    add_column :notifications, :client_email, :text
    add_column :notifications, :client_sms, :text
  end
end
