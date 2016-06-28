class AddAttachmentImageToPdfSettings < ActiveRecord::Migration
  def self.up
    change_table :pdf_settings do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :pdf_settings, :image
  end
end
