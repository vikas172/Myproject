class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.integer :zip_code
      t.string :country

      t.timestamps
    end
  end
end
