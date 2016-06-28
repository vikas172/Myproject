class AddPhoneToEmailScrapers < ActiveRecord::Migration
  def change
    add_column :email_scrapers, :phone, :string
  end
end
