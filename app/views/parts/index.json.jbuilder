json.array!(@parts) do |part|
  json.extract! part,  :id, :item_code, :description, :purchase_price, :purchase_code, :sales_price, :sales_code, :profit, :margin, :created_at, :updated_at
  json.url item_url(part, format: :json)
end
