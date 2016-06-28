class ChangeDateFormatInEvents < ActiveRecord::Migration
  def change
   change_column :events, :start_time, :time
   change_column :events, :end_time, :time
  end
end
