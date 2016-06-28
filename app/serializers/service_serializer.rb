class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :date, :vehicle_id, :odometer, :mark_as_void, :services_completed, :vendor, :reference, :comment, :labor, :parts, :tax, :total
end
