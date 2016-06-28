class AddDomainToEmailScrapers < ActiveRecord::Migration
  def change
    add_column :email_scrapers, :domain, :string
  end
end
