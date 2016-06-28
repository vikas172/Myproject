class AddFieldTypeToBasicTask < ActiveRecord::Migration
  def change
  	add_column :basic_tasks, :event_type, :string
    add_column :events, :event_type, :string
    add_column :visit_schedules, :event_type, :string
  end
end
