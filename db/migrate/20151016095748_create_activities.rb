class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :property_id
      t.integer :email_notification_id
      t.integer :note_id
      t.integer :user_id

      t.timestamps
    end
  end
end
