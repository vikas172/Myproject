json.array!(@keys) do |key|
  json.extract! key, :id, :ivr_id, :digit
  json.url key_url(key, format: :json)
end
