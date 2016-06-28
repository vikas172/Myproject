json.array!(@items) do |item|
  json.extract! item, :id, :name, :description, :product_model_number, :vendor_part_number, :vendor_name, :quantity, :unit_value, :value, :vendor_url, :category, :location
  json.url item_url(item, format: :json)
end
