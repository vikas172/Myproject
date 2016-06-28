class CreateSupports < ActiveRecord::Migration
  def change
    create_table :supports do |t|
      t.string :email
      t.string :title
      t.text :description
      t.string :phone_number
      t.string :about

      t.timestamps
    end
  end
end
