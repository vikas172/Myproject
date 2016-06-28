class AddDistanceFieldToExpense < ActiveRecord::Migration
  def change
  	add_column :expenses, :exp_category, :string
  	add_column :expenses, :miles, :float
  	add_column :expenses, :unit, :string
  	add_column :expenses, :dist_date, :date
  	add_column :expenses, :dist_amount, :float
  	add_column :expenses, :dist_category, :string
  	add_column :expenses, :dist_comment, :text
  end
end
