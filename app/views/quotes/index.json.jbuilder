json.array!(@quotes) do |quote|
  json.extract! quote, :id, :tax, :discount, :discount_type, :require_deposit, :require_deposit_type, :client_message
  json.url quote_url(quote, format: :json)
end
