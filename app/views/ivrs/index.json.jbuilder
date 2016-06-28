json.array!(@ivrs) do |ivr|
  json.extract! ivr, :id, :name, :phone, :status, :user_id
  json.url ivr_url(ivr, format: :json)
end
