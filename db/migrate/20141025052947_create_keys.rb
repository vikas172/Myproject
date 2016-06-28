class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.integer :ivr_id
      t.string :digit

      t.timestamps
    end
  end
end
