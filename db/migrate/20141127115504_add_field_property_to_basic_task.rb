class AddFieldPropertyToBasicTask < ActiveRecord::Migration
  def change
    add_column :basic_tasks, :property_id, :integer
  end
end
