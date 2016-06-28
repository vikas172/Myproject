class AddAttachmentCompanyLogoToCompanies < ActiveRecord::Migration
  def self.up
    change_table :companies do |t|
      t.attachment :company_logo
    end
  end

  def self.down
    remove_attachment :companies, :company_logo
  end
end
