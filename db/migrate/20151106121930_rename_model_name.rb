class RenameModelName < ActiveRecord::Migration
  def change
  	 rename_table :property_sms, :sms_properties
  	 rename_column :activities, :property_sms_id, :sms_property_id
  end
end
