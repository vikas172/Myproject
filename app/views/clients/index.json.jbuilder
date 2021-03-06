json.array!(@clients) do |client|
  json.extract! client, :id, :initial, :first_name, :last_name, :company_name, :primary_company, :street1, :street2, :city, :state, :zip_code, :country, :phone_initial, :phone_number, :email_initial, :email
  json.url client_url(client, format: :json)
end
