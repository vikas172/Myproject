class ChangeDataTypeToRepeat < ActiveRecord::Migration
  def change
  	change_column :repeats, :day_holder, :string
  end
end
