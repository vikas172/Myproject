class CreateEmailNotifications < ActiveRecord::Migration
  def change
    create_table :email_notifications do |t|
      t.string :from
      t.string :to
      t.text :body
      t.integer :user_id

      t.timestamps
    end
  end
end
