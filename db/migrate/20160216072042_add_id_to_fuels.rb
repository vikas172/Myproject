class AddIdToFuels < ActiveRecord::Migration
  def change
    add_column :fuels, :user_id, :integer
  end
end
