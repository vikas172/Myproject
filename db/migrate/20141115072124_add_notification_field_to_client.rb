class AddNotificationFieldToClient < ActiveRecord::Migration
  def change
    add_column :clients, :mobile_number, :string
    add_column :clients, :personal_email, :string
    add_column :clients, :preference_notification, :string
  end
end
