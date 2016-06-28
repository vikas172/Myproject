class AddFieldPropertyIdToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :property_id, :integer
  end
end
