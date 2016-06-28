class CreateRepeats < ActiveRecord::Migration
  def change
    create_table :repeats do |t|
    	t.string :frequency
    	t.integer :daily_interval
    	t.integer :weekly_interval
    	t.integer :day_holder
    	t.integer :monthly_interval
    	t.string :monthly_rule_type
    	t.integer :calender_day
    	t.string :calander_week
    	t.integer :yearly_interval
    	t.string :invoicing
    	t.string :visits
    	t.integer :job_id
      t.timestamps
    end
  end
end
