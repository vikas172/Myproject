class AddSeoMarketingToEmailScrapers < ActiveRecord::Migration
  def change
    add_column :email_scrapers, :seo_marketing, :boolean
  end
end
