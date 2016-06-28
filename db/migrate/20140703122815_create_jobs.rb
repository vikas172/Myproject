class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.text :description
      t.boolean :scheduled
      t.date :start_date
      t.date :end_date
      t.string :visits
      t.time :start_time
      t.time :end_time
      t.string :crew
      t.string :invoicing
      t.string :invoice_period
      t.date :first_invoice_on

      t.timestamps
    end
  end
end
