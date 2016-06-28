json.array!(@properties) do |property|
  json.extract! property, :id, :street, :street2, :city, :state, :zipcode, :country
  json.url property_url(property, format: :json)
end
