class RenameColumnNameGeneralInfo < ActiveRecord::Migration
  def change
  	rename_column :general_infos, :time_zone, :language
  	rename_column :general_infos, :date_format, :work_start_day
  	rename_column :general_infos, :time_format, :work_end_day
  end
end
