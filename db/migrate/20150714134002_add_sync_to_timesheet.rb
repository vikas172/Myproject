class AddSyncToTimesheet < ActiveRecord::Migration
  def change
    add_column :timesheets, :sync_type, :boolean, :default => false
  end
end
