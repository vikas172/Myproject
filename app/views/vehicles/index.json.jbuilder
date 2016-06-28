json.array!(@vehicles) do |vehicle|
  json.extract! vehicle, :id, :vehicle_name, :vin_no, :vehicle_type, :year, :make, :model, :trim, :license_plate, :registation, :status, :group, :driver, :ownership, :color, :body_type, :body_subtype, :msrp
  json.url vehicle_url(vehicle, format: :json)
end
