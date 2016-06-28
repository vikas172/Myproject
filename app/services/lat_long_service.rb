class LatLongService
  def initialize(params)
    @ip = params[:ip]
  end

  def fetch
  	uri = URI("http://ip-api.com/json/#{@ip}")
  	res = Net::HTTP.get_response(uri)
  	begin
  		response = res.body
  		parsed_response = JSON.parse(response)
  		{lat: parsed_response["lat"], lon: parsed_response["lon"]}
  	rescue
  		{lat: nil, long: nil}
  	end
  end
end
