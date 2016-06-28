class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :email_initial
      t.string :email
      t.integer :client_id
      t.string :primary_email

      t.timestamps
    end
  end
end
