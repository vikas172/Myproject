class AddFieldJobOrgerToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :job_order, :integer,:default=> 0
  end
end
