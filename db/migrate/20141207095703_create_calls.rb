class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.string :call_sid
      t.integer :ivr_id
      t.string :caller
      t.string :caller_city
      t.string :caller_state

      t.timestamps
    end
  end
end
