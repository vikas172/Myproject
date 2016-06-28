class AddStatementFieldToUser < ActiveRecord::Migration
  def change
    add_column :users, :statement, :text
    add_column :users, :statement_order, :string
  end
end
