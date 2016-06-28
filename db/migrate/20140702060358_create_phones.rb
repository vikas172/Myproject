class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :phone_initial
      t.string :phone_number
      t.string :primary_phone
      t.integer :client_id

      t.timestamps
    end
  end
end
