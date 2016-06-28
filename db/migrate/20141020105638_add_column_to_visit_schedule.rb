class AddColumnToVisitSchedule < ActiveRecord::Migration
  def change
  	add_column :visit_schedules, :completed_by, :string
  end
end
