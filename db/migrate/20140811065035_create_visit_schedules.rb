class CreateVisitSchedules < ActiveRecord::Migration
  def change
    create_table :visit_schedules do |t|
      t.string :title
      t.boolean :any_time
      t.date :start_date
      t.date :end_date
      t.time :start_time
      t.time :end_time
      t.string :team_reminder
      t.text :description
      t.integer :job_id
      t.integer :user_id
      t.string :assigned_users

      t.timestamps
    end
  end
end
