class AddMailSentToEmailScrapers < ActiveRecord::Migration
  def change
    add_column :email_scrapers, :mail_sent, :boolean
  end
end
