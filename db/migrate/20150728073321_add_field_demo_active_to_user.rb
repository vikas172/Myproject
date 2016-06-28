class AddFieldDemoActiveToUser < ActiveRecord::Migration
  def change
    add_column :users, :demo_active, :boolean, :default => true
  end
end
