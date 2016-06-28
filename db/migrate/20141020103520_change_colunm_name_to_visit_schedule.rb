class ChangeColunmNameToVisitSchedule < ActiveRecord::Migration
  def change
  	remove_column :visit_schedules, :assigned_users
  	add_column :visit_schedules, :crew, :string
  end
end
