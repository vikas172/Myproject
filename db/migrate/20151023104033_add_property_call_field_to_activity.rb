class AddPropertyCallFieldToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :property_call_id, :integer
  end
end
