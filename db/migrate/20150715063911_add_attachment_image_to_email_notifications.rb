class AddAttachmentImageToEmailNotifications < ActiveRecord::Migration
  def self.up
    change_table :email_notifications do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :email_notifications, :image
  end
end
