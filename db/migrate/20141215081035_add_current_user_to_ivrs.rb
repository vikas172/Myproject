class AddCurrentUserToIvrs < ActiveRecord::Migration
  def change
    add_column :ivrs, :user_email, :string
  end
end
