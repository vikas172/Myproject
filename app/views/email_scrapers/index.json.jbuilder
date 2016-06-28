json.array!(@email_scrapers) do |email_scraper|
  json.extract! email_scraper, :id, :name, :email, :profession, :city, :state, :address, :country
  json.url email_scraper_url(email_scraper, format: :json)
end
