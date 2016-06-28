class RemoveColumToExpense < ActiveRecord::Migration
  def change
  	remove_column :expenses, :dist_reimbursable
  	remove_column :expenses, :dist_billable
  	remove_column :expenses, :dist_comment
  	remove_column :expenses, :dist_category
  	remove_column :expenses, :dist_date
  	remove_column :expenses, :dist_amount
  	add_column :expenses, :expense_type, :string
  end
end
