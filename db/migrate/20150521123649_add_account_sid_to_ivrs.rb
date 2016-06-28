class AddAccountSidToIvrs < ActiveRecord::Migration
  def change
    add_column :ivrs, :account_sid, :string , :default => "ACc9f80c975d0574058948613554ca5adf"
    add_column :ivrs, :auth_token, :string , :default => "4dc2192cd7088ed3728b9899ff3b15bf"
  end
end
