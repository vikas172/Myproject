json.array!(@classifieds) do |classified|
  json.extract! classified, :id, :privacy, :contact_phone, :contact_text, :phone_number, :contact_name, :posting_title, :specific_location, :postal_code, :posting_body, :show_on_map, :street, :city, :state, :zipcode, :contact_ok
  json.url classified_url(classified, format: :json)
end
