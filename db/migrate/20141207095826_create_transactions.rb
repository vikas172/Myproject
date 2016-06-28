class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :call_id
      t.string :key_press
      t.integer :key_action_id
      t.string :recording

      t.timestamps
    end
  end
end
