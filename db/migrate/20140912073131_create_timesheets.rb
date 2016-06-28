class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
    	t.integer :user_id
    	t.date    :start_date 
    	t.boolean :auto_start_timer 
    	t.integer :work_order_id 
    	t.string  :label 
    	t.text    :note 
    	t.time    :start_time 
    	t.time    :end_time 
    	t.time    :duration
      t.timestamps
    end
  end
end
