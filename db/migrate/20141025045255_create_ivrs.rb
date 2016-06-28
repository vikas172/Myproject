class CreateIvrs < ActiveRecord::Migration
  def change
    create_table :ivrs do |t|
      t.string :name
      t.string :phone
      t.boolean :status
      t.integer :user_id

      t.timestamps
    end
  end
end
