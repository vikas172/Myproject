class AddAttachmentPhotoToTeamMembers < ActiveRecord::Migration
  def self.up
    change_table :team_members do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :team_members, :photo
  end
end
