class AddAttachmentServiceImageToServices < ActiveRecord::Migration
  def self.up
    change_table :services do |t|
      t.attachment :service_image
    end
  end

  def self.down
    remove_attachment :services, :service_image
  end
end
