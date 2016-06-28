class CreateBeta < ActiveRecord::Migration
  def change
    create_table :beta do |t|
      t.string :name
      t.string :email
      t.text :feedback

      t.timestamps
    end
  end
end
