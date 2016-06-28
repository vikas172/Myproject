class AddDefaultUnitCustomExpense < ActiveRecord::Migration
  def change
  	add_column :custom_expenses, :default_unit, :string
  end
end
