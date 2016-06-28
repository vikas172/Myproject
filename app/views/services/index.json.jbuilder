json.array!(@services) do |service|
  json.extract! service, :id, :date, :vehicle_id, :odometer, :mark_as_void, :services_completed, :vendor, :reference, :comment, :labor, :parts, :tax, :total
  json.url service_url(service, format: :json)
end
