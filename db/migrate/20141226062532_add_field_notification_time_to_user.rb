class AddFieldNotificationTimeToUser < ActiveRecord::Migration
  def change
    add_column :users, :message_notify, :string
  end
end
