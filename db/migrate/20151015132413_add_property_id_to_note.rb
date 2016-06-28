class AddPropertyIdToNote < ActiveRecord::Migration
  def change
    add_column :notes, :property_id, :integer
  end
end
