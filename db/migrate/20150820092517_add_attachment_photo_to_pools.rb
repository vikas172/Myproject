class AddAttachmentPhotoToPools < ActiveRecord::Migration
  def self.up
    change_table :pools do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :pools, :photo
  end
end
