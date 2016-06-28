class PostcardsController < ApplicationController
  require 'lob'

  def index
    @lob = Lob.load(api_key: "test_01e37d86cdc238169918f287c319f650d6b")
    @lobs=@lob.postcards.list(count: 2, offset: 0)
  end

#Lob API Create with templates
  def create
    @lob = Lob.load(api_key: "test_01e37d86cdc238169918f287c319f650d6b")
    template_file = ERB.new(File.open(File.join(Rails.root, 'app', 'views', 'postcards', 'postcard_front.html')).read)
    custom_html = template_file.result(binding)
    if !params[:filters].keys.blank?
      params[:filters].keys.each do |property_id|
        @property= Property.find(property_id) if (property_id.to_i !=0)
        if @property.present?
          @client = @property.client
          if @client.street1.blank?
            if current_user.street.blank?
              company= current_user.company
              @results=@lob.postcards.create(description: params[:postcards][:message] ,to: {name:@client.first_name,address_line1: @property.street,city: @property.city,state: @property.state, country: "US",zip: @property.zipcode},from: {name: current_user.full_name,address_line1: company.street,city: company.city,state: company.state,country: "US",zip: company.zipcode},front: "https://lob.com/postcardfront.pdf",back: "https://lob.com/postcardback.pdf") rescue ""
            else
              @results=@lob.postcards.create(description: params[:postcards][:message] ,to: {name:@client.first_name,address_line1: @property.street,city: @property.city,state: @property.state, country: "US",zip: @property.zipcode},from: {name: current_user.full_name,address_line1: current_user.street,city: current_user.city,state: current_user.state,country: "US",zip: current_user.zipcode},front: "https://lob.com/postcardfront.pdf",back: "https://lob.com/postcardback.pdf") rescue ""
            end
          else
            if current_user.street.blank?
              company= current_user.company
              @results=@lob.postcards.create(description: params[:postcards][:message] ,to: {name:@client.first_name,address_line1: @client.street1,city: @client.city,state: @client.state, country: "US",zip: @client.zip_code},from: {name: current_user.full_name,address_line1: company.street,city: company.city,state: company.state,country: "US",zip: company.zipcode},front: "https://lob.com/postcardfront.pdf",back: "https://lob.com/postcardback.pdf") rescue ""
            else
              @results=@lob.postcards.create(description: params[:postcards][:message] ,to: {name:@client.first_name,address_line1: @client.street1,city: @client.city,state: @client.state, country: "US",zip: @client.zip_code},from: {name: current_user.full_name,address_line1: current_user.street,city: current_user.city,state: current_user.state,country: "US",zip: current_user.zipcode},front: "https://lob.com/postcardfront.pdf",back: "https://lob.com/postcardback.pdf") rescue ""
            end
          end
        end
      end
    end
    
    if !@results.blank?
      Postcard.create(:user_id=>current_user.id ,post_card_id: @results["id"],:message=>params[:postcards][:message])
    end

    redirect_to :back
    # @lob = Lob.load(api_key: "test_01e37d86cdc238169918f287c319f650d6b")
    # template_file = ERB.new(File.open(File.join(Rails.root, 'app', 'views', 'postcards', 'postcard_front.html')).read)
    # custom_html = template_file.result(binding)
    # @results=@lob.postcards.create(description: params[:postcards][:message] ,to: {name:params[:postcards][:to_name],address_line1: params[:postcards][:to_street],city: params[:postcards][:to_city],state: params[:postcards][:to_state], country: "US",zip: params[:postcards][:to_zip]},from: {name: params[:postcards][:from_name],address_line1: params[:postcards][:from_street],city: params[:postcards][:from_city],state: params[:postcards][:from_state],country: "US",zip: params[:postcards][:from_zip]},front: "https://lob.com/postcardfront.pdf",back: "https://lob.com/postcardback.pdf")
  end

  private
    def job_params
    	params.require(:postcards).permit(:to_name, :to_street, :to_city, :to_state, :to_zipcode, :from_name, :from_street, :form_city, :form_state, :from_zipcode,:user_id,:country)
  	end
end
