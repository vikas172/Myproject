class AddColumnClintIdToChemicals < ActiveRecord::Migration
  def change
  	add_column :chamicals, :user_id, :integer
  end
end
