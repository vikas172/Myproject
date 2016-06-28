class AddAttachmentVehicleImageToVehicles < ActiveRecord::Migration
  def self.up
    change_table :vehicles do |t|
      t.attachment :vehicle_image
    end
  end

  def self.down
    remove_attachment :vehicles, :vehicle_image
  end
end
