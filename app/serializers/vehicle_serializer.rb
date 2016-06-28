class VehicleSerializer < ActiveModel::Serializer
  attributes :id, :vehicle_name, :vin_no, :type, :year, :make, :model, :trim, :license_plate, :registation, :status, :group, :driver, :ownership, :color, :body_type, :body_subtype, :msrp
end
