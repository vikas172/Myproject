class CreateEmailScrapers < ActiveRecord::Migration
  def change
    create_table :email_scrapers do |t|
      t.string :name
      t.string :email
      t.string :profession
      t.string :city
      t.string :state
      t.text :address
      t.string :country

      t.timestamps
    end
  end
end
