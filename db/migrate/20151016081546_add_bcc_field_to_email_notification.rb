class AddBccFieldToEmailNotification < ActiveRecord::Migration
  def change
    add_column :email_notifications, :bcc, :string
    add_column :email_notifications, :cc, :string
    add_column :email_notifications, :subject, :string
  end
end
