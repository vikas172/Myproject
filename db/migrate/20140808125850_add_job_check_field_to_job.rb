class AddJobCheckFieldToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :job_complete, :boolean, default: false
  end
end
