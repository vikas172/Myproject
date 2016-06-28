class CreateKeyActions < ActiveRecord::Migration
  def change
    create_table :key_actions do |t|
      t.integer :key_id
      t.integer :action_type_id
      t.integer :sequence
      t.string :say
      t.string :play
      t.string :dial
      t.string :record
      t.string :gather
      t.string :sms

      t.timestamps
    end
  end
end
