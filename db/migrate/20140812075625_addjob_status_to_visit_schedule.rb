class AddjobStatusToVisitSchedule < ActiveRecord::Migration
  def change
  	add_column :visit_schedules, :job_status, :string
  	add_column :visit_schedules, :job_required, :string
  	add_column :visit_schedules, :job_complete, :boolean, default: false
  	add_column :visit_schedules, :complete_on, :date
  end
end
