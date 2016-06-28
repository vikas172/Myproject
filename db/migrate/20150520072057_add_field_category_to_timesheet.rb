class AddFieldCategoryToTimesheet < ActiveRecord::Migration
  def change
    add_column :timesheets, :custom_category_id, :integer
    rename_column :timesheets, :work_order_id, :job_id
    rename_column :expenses, :work_order_id, :job_id

  end
end
