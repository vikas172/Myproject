json.array!(@numbers) do |number|
  json.extract! number, :id, :account_sid, :auth_token, :phone_number, :phone_sid, :user_id
  json.url number_url(number, format: :json)
end
