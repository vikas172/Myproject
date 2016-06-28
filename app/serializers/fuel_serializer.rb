class FuelSerializer < ActiveModel::Serializer
  attributes :id, :vehicle_id, :date, :odometer, :mark_as_void, :price, :fuel_type, :vandor_name, :reference, :mark_as_expense, :partial_fuel_up, :comment
end
