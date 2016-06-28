class AddPropertyIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :property_id, :integer
  end
end
