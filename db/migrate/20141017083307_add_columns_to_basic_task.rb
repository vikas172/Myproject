class AddColumnsToBasicTask < ActiveRecord::Migration
  def change
  	add_column :basic_tasks, :is_completed, :boolean, default: false
  	add_column :basic_tasks, :completed_date, :date
  	add_column :basic_tasks, :complete_by, :integer
  end
end
