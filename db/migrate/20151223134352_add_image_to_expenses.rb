class AddImageToExpenses < ActiveRecord::Migration
  def change
  	add_column :expenses, :expense_image, :string
  end
end
