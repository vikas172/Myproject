class AddUserIdToIvrs < ActiveRecord::Migration
  def change
    add_column :ivrs, :free, :boolean
  end
end
