class AddIdToServiceReminders < ActiveRecord::Migration
  def change
    add_column :service_reminders, :user_id, :integer
  end
end
