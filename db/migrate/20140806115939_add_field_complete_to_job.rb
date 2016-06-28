class AddFieldCompleteToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :job_status, :string
    add_column :jobs, :job_required, :string
  end
end
