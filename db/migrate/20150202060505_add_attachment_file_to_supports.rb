class AddAttachmentFileToSupports < ActiveRecord::Migration
  def self.up
    change_table :supports do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :supports, :file
  end
end
