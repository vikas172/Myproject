class AddBillabeToTimesheet < ActiveRecord::Migration
  def change
    add_column :timesheets, :billable, :boolean, default: false
  end
end
