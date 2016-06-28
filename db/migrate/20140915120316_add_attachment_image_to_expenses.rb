class AddAttachmentImageToExpenses < ActiveRecord::Migration
  def self.up
    change_table :expenses do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :expenses, :image
  end
end
