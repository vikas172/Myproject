class AddRecepitNumberToCharge < ActiveRecord::Migration
  def change
    add_column :charges, :account_status, :string
  end
end
