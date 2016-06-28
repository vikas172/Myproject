class AddColumnToExpense < ActiveRecord::Migration
  def change
  	add_column :expenses, :pending_payment, :boolean, default: false
  end
end
