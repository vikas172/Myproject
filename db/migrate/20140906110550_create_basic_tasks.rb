class CreateBasicTasks < ActiveRecord::Migration
  def change
    create_table :basic_tasks do |t|
      t.boolean :all_day, default: true
      t.date :start_at_date
      t.date :end_at_date
      t.time :start_at_time
      t.time :end_at_time
      t.string :title
      t.string :description
      t.string :repeat
      t.integer :user_id

      t.timestamps
    end
  end
end
