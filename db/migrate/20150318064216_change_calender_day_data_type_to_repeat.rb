class ChangeCalenderDayDataTypeToRepeat < ActiveRecord::Migration
  def change
  	change_column :repeats, :calender_day, :string
  end
end
