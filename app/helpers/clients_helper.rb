module ClientsHelper

  def property_add(params,client)
    if !params[:client][:properties].blank?
      if (!params[:client][:properties]["street"].blank?) ||(!params[:client][:properties]["street2"].blank?)||(!params[:client][:properties]["city"].blank?)||(!params[:client][:properties]["state"].blank?)||(!params[:client][:properties]["country"].blank?)||(!params[:client][:properties]["zipcode"].blank?)
        @property=Property.new
        @geocode=[]
        if !params[:client][:properties]["street"].blank?
          @property.street=params[:client][:properties]["street"]
        end
         if !params[:client][:properties]["street2"].blank?
          @property.street2=params[:client][:properties]["street2"]
        end
         if !params[:client][:properties]["city"].blank?
          @property.city=params[:client][:properties]["city"]
        end
         if !params[:client][:properties]["state"].blank?
          @property.state=params[:client][:properties]["state"]
        end
         if !params[:client][:properties]["zipcode"].blank?
          @property.zipcode=params[:client][:properties]["zipcode"]
        end
        if !params[:client][:properties]["country"].blank?
          @property.country=params[:client][:properties]["country"]
        end
        @property.client_id=client
        @property.user_id=current_user.id
        @location=gecode_find(@property, @geocode)
        @property.latitude=@location[0] unless @location.blank?
        @property.longitude=@location[1] unless @location.blank?
        @property.save
      end  
    end
  end



  def client_property(params,client)

    if !params[:client][:properties].blank?
      if (!params[:client][:properties]["street"].blank?) ||(!params[:client][:properties]["street2"].blank?)||(!params[:client][:properties]["city"].blank?)||(!params[:client][:properties]["state"].blank?)||(!params[:client][:properties]["country"].blank?)||(!params[:client][:properties]["zipcode"].blank?)
      
        @property=client.properties.first
        if !params[:client][:properties]["street"].blank?
   
          @property.street=params[:client][:properties]["street"]
        end
         if !params[:client][:properties]["street2"].blank?
          @property.street2=params[:client][:properties]["street2"]
        end
         if !params[:client][:properties]["city"].blank?
          @property.city=params[:client][:properties]["city"]
        end
         if !params[:client][:properties]["state"].blank?
          @property.state=params[:client][:properties]["state"]
        end
         if !params[:client][:properties]["zip_ode"].blank?
          @property.zipcode=params[:client][:properties]["zipcode"]
        end
        if !params[:client][:properties]["country"].blank?
          @property.country=params[:client][:properties]["country"]
        end
        @property.client_id=client.id
        @property.user_id=current_user.id
        @property.save
      end  
    end
  end
  def link_url(client)
    return link_to (client.properties[0].try(:street)+" "+client.properties[0].try(:street2)+" "+client.properties[0].try(:city)+" "+client.properties[0].try(:state)).html_safe ,property_path,:style=>"text-decoration: -moz-anchor-decoration;" if params[:value1]=="pid"
  end

  def quote_find_url(value)
    @quote=Quote.find(value)
    return @quote
  end
  def name_client_display(client)
    return   "Quote for"+" "+client.try(:initial) +" "+ client.try(:first_name) +" "+ client.try(:last_name)
  end

   def name_client1_display(client)
    return   client.try(:initial) +" "+ client.try(:first_name) +" "+ client.try(:last_name)
  end

  def export_vcard(clients,card)
    @clients=clients
    @clients.each do |client|
      card << Vpim::Vcard::Maker.make2 do |maker|
        maker.add_name do |name|
          name.given = client.first_name 
          name.family= client.last_name
        end
        maker.add_addr do |address|
          address.street = client.try(:street1)  
          address.locality = client.try(:city)
          address.region = client.try(:state)
          address.postalcode = client.try(:zip_code)
          address.country = client.try(:country)
        end
      end
    end
  end
  
 def job_total_number(client)
  @client=client
  @jobs=[]
  if !@client.properties.blank?
    @client.properties.each do |property|
      if !property.jobs.blank?
        property.jobs.each do |job|
          @jobs << job
        end
      end  
    end
  end
  
  return @jobs.count
 end

  def quote_total_number(client)
    @client=client
    @quotes=[]
    if !@client.properties.blank?
      @client.properties.each do |property|
        if !property.quotes.blank?
          property.quotes.each do |quote|
            @quotes << quote
          end
        end  
      end
    end
    return @quotes.count
  end

  def csv_file_download(client,csv)
    if !client.country.blank?
      client_country=Carmen::Country.coded(client.country).name
    else
      client_country=""
    end
    csv << [client.try(:initial), client.first_name, client.last_name, client.company_name, client.try(:street1), client.try(:street2), client.try(:city), client.try(:state), client.try(:zip_code), client_country,  client.try(:phone_number), client.try(:user_id), client.try(:mobile_number), client.try(:personal_email)]
  end

  def upload_client_csv(row,prop)
    
    unless prop
      country = Carmen::Country.named(row[9]).alpha_2_code rescue ""
      client= Client.new(:initial => row[0], :first_name => row[1], :last_name => row[2], :company_name => row[3], :street1 => row[4], :street2 => row[5], :city => row[6], :state => row[7], :zip_code => row[8],:country=>country ,:phone_number => row[10],:mobile_number=>row[12],:personal_email=>row[13])
      client.user_id=current_user.id
      client.save
    else
      client = current_user.clients.last
    end
    @property = client.properties.new(:street => row[14], :city => row[15], :state => row[16],  :zipcode => row[17],:country => row[18])
    @property.tag_list.add(row[32])
    @property.user_id = current_user.id
    @property.save
  end

  def active_job_display(jobs)
    @active_jobs = []
    jobs.each do |job|
      @count=check_job_invoice_genrate(job)
      if @count== 0
        @active_jobs<< job
      end
    end
    return @active_jobs
  end

  def check_job_invoice_genrate(job)
    @invoices=Invoice.where(:user_id=>current_user.id)
    @count=0
    if !@invoices.blank?
      @invoices.each do |invoice|
        if !invoice.jobs_id.blank? 
          if invoice.jobs_id.include? job.id.to_s
            @count=@count+1
          end
        end
      end
    end
    return @count
  end

  def active_quote_display(quotes)
    @active_quotes=[]
    quotes.each do |quote|
      unless ((quote.sent) && (quote.archive))
        @active_quotes <<quote
      end
    end
    return @active_quotes
  end

  def active_invoice_display(invoices)
    @active_invoices=[]
    invoices.each do |invoice|
      unless ((invoice.mark_sent) &&(invoice.invoice_paid))
        @active_invoices <<invoice
      end
    end
    return @active_invoices
  end

  def property_display_client_show(value)
    @property=Property.find(value)
    @property_display=@property.try(:street)+" "+ @property.try(:street2)+" "+@property.try(:city)
  end

  #get note on client
  def get_note(note_id)
    @note=Note.find(note_id)
  end

  #get carmen country code
  def get_carmen_country_code(country)
    @country = Carmen::Country.coded(country)
  end

  #Add values within custom field on client view
  def custom_field_select(custom_field)
    @select_custom=[]
    custom_field.value_type.each_with_index do |value_type,index|
      if index==0
      else
        @select_custom << value_type
      end
    end
    return @select_custom
  end

  def get_marketing_content(content,property)
    company= property.user.company
    if company.blank?
      return content.gsub("{{Company_Name}}", property.user.company_name ).gsub("{{Client_First_Name}}",property.client.first_name).gsub("{{Client_Last_Name}}",property.client.last_name).gsub("{{Pool_Street}}",property.try(:street)).gsub("{{Pool_City}}",property.try(:city)).gsub("{{Pool_State}}",property.try(:state)).gsub("{{Client_Email}}",property.client.try(:personal_email))    
    elsif company.street.blank?
      return content.gsub("{{Company_Name}}", property.user.company_name ).gsub("{{Client_First_Name}}",property.client.first_name).gsub("{{Client_Last_Name}}",property.client.last_name).gsub("{{Pool_Street}}",property.try(:street)).gsub("{{Pool_City}}",property.try(:city)).gsub("{{Pool_State}}",property.try(:state)).gsub("{{Client_Email}}",property.client.try(:personal_email)) 
    else
      return content.gsub("{{Company_Name}}", property.user.company_name ).gsub("{{Client_First_Name}}",property.client.first_name).gsub("{{Client_Last_Name}}",property.client.last_name).gsub("{{Pool_Street}}",property.try(:street)).gsub("{{Pool_City}}",property.try(:city)).gsub("{{Pool_State}}",property.try(:state)).gsub("{{Client_Email}}",property.client.try(:personal_email)).gsub("{{Company_Street}}",company.try(:street)).gsub("{{Company_City}}",company.try(:city)).gsub("{{Company_State}}",company.try(:state))
    end 
  end

  private 
  def url_conditions(params,client,format)
    @client=client
    if params[:property]!= "client"
      property_add(params,@client.id)
      if params[:job]== "job" 
        if params[:work]=="work"
          if !@property.blank?
            format.html { redirect_to new_job_path(:property_id=>@property.id,:work=>"work") }
          end  
          format.html { redirect_to new_property_path(:client_id=>@client.id,:job_prop=>params[:job],:work=>"work") , notice: 'Client was successfully created.'} 
        else
          if !@property.blank?
            format.html { redirect_to new_job_path(:property_id=>@property.id), notice: 'Client was successfully created.' }
          end  
          format.html { redirect_to new_property_path(:client_id=>@client.id,:job_prop=>params[:job]) , notice: 'Client was successfully created.'}  
        end
         
        elsif params[:property_quote]== "quote"
          if params[:work]=="work"
            if @property.blank?
              format.html { redirect_to new_property_path(:client_id=>@client.id,:quote_create=>params[:property_quote],:work=>"work"), notice: 'Client was successfully created.' }
            else
              format.html { redirect_to new_quote_path(:property_id=>@property.id,:client_id=>@client.id) }
            end
          else
           if @property.blank?
              format.html { redirect_to new_property_path(:client_id=>@client.id,:quote_create=>params[:property_quote]), notice: 'Client was successfully created.' }
            else
              format.html { redirect_to new_quote_path(:property_id=>@property.id,:client_id=>@client.id )}
            end  
          end
       
        elsif params[:invoice]=="invoice"
            format.html { redirect_to new_invoice_path(:client_id=>@client.id) , notice: 'Client was successfully created.'}
        end   
      else
        format.html { redirect_to new_property_path(:client_id=>@client.id), notice: 'Client was successfully created.' }
      end
      if params[:property]=="property"
        format.html { redirect_to new_property_path(:client_id=>@client.id) , notice: 'Client was successfully created.'}
      end
      format.html { redirect_to @client, notice: 'Client was successfully created.' }
      format.json { render :show, status: :created, location: @client }
    end


    def property_after_create_url(params,property,format)
      
      if params[:work]=="work"
        format.html {redirect_to property_path(:id=>@property.id,:work=>params[:work],:client_id=>params[:client_id]) }
      elsif params[:job_create]=="job_create_action" && params[:client_show]=="client_show"
        format.html { redirect_to new_job_path(:client_id=>params[:client_id],:value=>params[:client_show])}
      elsif params[:client_show]=="client_show" && params[:quote_create]=="quote"
        format.html { redirect_to new_quote_path(:property_id=>@property.id,:value=>params[:client_show],:client_id=>params[:client_id])}          
      elsif params[:client_show]=="client_show"
        format.html {redirect_to property_path(:id=>@property.id,:client_show=>params[:client_show],:client_id=>params[:client_id]) }
      elsif params[:quote_create]=="quote"
        format.html { redirect_to new_quote_path(:property_id=>@property.id), notice: 'Property was successfully created.'}
      elsif params[:job_create]== "job" && params[:date].nil?
        format.html { redirect_to new_job_path(:property_id=>@property.id), notice: 'Property was successfully created.'}
      elsif params[:job_create]== "job" && !params[:date].nil?
        format.html { redirect_to new_job_path(:property_id=>@property.id,:client_id=>params[:client_id],:date=>params[:date]), notice: 'Property was successfully created.'}  
      elsif params[:client_view]=="client_view"
        format.html {redirect_to property_path(:id=>@property.id,:view=>params[:client_view],:client_id=>params[:client_id]), notice: 'Property was successfully created.'  }          
      elsif params[:client_id] && params[:invoice_id]
        format.html {redirect_to property_path(:id=>@property.id,:invoice_id=>params[:invoice_id],:client_id=>params[:client_id])}
      elsif params[:action_from] == "chamicals"
        format.html {redirect_to new_chamical_path(:property_id=>@property.id)}
      end
      format.html { redirect_to property_path(:id=>@property.id) , notice: 'Property was successfully created.' }
      format.json { render :show, status: :created, location: @property }
    end
end
