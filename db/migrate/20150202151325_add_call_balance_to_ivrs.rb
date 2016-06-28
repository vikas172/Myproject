class AddCallBalanceToIvrs < ActiveRecord::Migration
  def change
    add_column :ivrs, :call_balance, :integer
  end
end
