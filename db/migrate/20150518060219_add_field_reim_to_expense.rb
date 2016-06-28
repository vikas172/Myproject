class AddFieldReimToExpense < ActiveRecord::Migration
  def change
  	add_column :expenses, :exp_reimbursable, :string
  	add_column :expenses, :exp_billable, :string
  	add_column :expenses, :dist_reimbursable, :string
  	add_column :expenses, :dist_billable, :string
  end
end
