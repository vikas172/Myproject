class AddAttachmentCompanyLogoToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :company_logo
    end
  end

  def self.down
    remove_attachment :users, :company_logo
  end
end
