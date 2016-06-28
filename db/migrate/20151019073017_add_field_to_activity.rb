class AddFieldToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :property_sms_id, :integer
  end
end
