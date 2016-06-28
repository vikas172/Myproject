class AddVerifiedToUser < ActiveRecord::Migration
  def change
    add_column :users, :verified, :boolean, :default => false
    add_column :users, :pin ,:string
  end
end
