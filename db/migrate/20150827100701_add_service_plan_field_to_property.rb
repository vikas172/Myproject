class AddServicePlanFieldToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :server_plan_id, :integer
  end
end
