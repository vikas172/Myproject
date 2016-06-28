class AddQuoteIdToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :quote_id, :integer
  end
end
