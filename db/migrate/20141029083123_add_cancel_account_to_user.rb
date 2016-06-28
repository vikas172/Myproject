class AddCancelAccountToUser < ActiveRecord::Migration
  def change
    add_column :users, :cancel_account, :boolean, default: false
  end
end
