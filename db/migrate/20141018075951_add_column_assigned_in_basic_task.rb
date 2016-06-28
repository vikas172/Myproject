class AddColumnAssignedInBasicTask < ActiveRecord::Migration
  def change
  	add_column :basic_tasks, :assigned_to, :string
  end
end
