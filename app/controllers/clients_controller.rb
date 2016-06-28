class ClientsController < ApplicationController
  include ClientsHelper
  include HomeHelper
  skip_before_filter  :verify_authenticity_token
  load_and_authorize_resource except:[:create]
  before_action :authenticate_user!
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  before_action :set_qb_service, only: [:create, :edit, :update, :destroy]

  def select
    @clients=Client.where(:user_id=>current_user.id)
  end

  def attach_client_sign
  end

  # GET /clients
  # GET /clients.json
  def index
    if current_user.user_type=="user"
      user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
      @clients = Client.where(:user_id=>user_type_id)
    else
      @properties=Property.where(:user_id=>current_user.id)
      @clients = Client.where(:user_id=>current_user.id)
    end
    @properties=Property.where(:user_id=>current_user.id)
    @tags=[]
    @clients.each do |client|
      if !client.tags.blank?
        client.tags.each do |tag|
          @tags << tag.name
        end
      end
    end
  end
 
  # GET /clients/1
  # GET /clients/1.json
  def show
    @payment_invoice = PaymentInvoice.new
    @client_initial_balance = @client.payment_invoices.where(transaction_type: "initial_balance")
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Clients")
    @custom_field_data=@client.custom_field if !@client.custom_field.blank?
    @quotes_all=[]
    @jobs_all=[]
    @properties=@client.properties
    if !@properties.blank?
      @properties.each do |property|
         @quotes_all << property.quotes  
         @jobs_all << property.jobs        
      end       
    end
    @quotes_all=@quotes_all.flatten
    @jobs_all=@jobs_all.flatten
    @invoices_all=@client.invoices
    @active_jobs=active_job_display(@jobs_all)
    @active_quotes=active_quote_display(@quotes_all)
    @active_invoices=active_invoice_display(@invoices_all)
    @event=Event.new
  end

  # GET /clients/new
  def new
    @client = Client.new
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Clients")
    @property_count = @client.properties.count
  end

  # GET /clients/1/edit
  def edit
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Clients")
    @custom_field_data=@client.custom_field
    @property_count = @client.properties.count
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)
    @client.custom_field=params[:custom_field]
    if current_user.user_type=="user"
      user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
      @client.user_id = user_type_id
    else
      @client.user_id = current_user.id
    end
    @client.mobile_number= params[:initial_phone]+params[:client][:mobile_number]
    respond_to do |format|
      if @client.save
        url_conditions(params,@client,format)
      else
        session[:client_error]= @client.errors.messages
        format.html { redirect_to request.referrer }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        if !@client.properties.blank?
          client_property(params,@client)
        else
          property_add(params,@client.id)
        end  
        @client.custom_field=params[:custom_field]
        @client.save  
        format.html { redirect_to client_path(@client, value: "client_show"), notice: 'Client was successfully updated.' }
        format.json { render :show, status: :ok, location: @client }
      else
        session[:client_error]= @client.errors.messages
        format.html { redirect_to request.referrer }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

#delete client   
  def delete_client
    @client=Client.find(params[:client_id])
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

# Eidt note veiw
  def edit_note
    @note=Note.find(params[:id])
    redirect_to :back
  end

#Update note after edit
  def update_note
    @note=Note.find(params[:note_id])
    @note.update(:note=>params[:note])
    if !params[:file].blank?
      file_upload(params[:file],@note.id)
    end
    redirect_to :back
  end

# client attachment destory
  def attachment_destroy
    @note=Note.find(params[:note_id])
    @attachment=Attachment.find(params[:id])
    @attachment.destroy
    respond_to do |format|
    format.js
    end
  end

# Client note destory  
  def note_destroy
    @note=Note.find(params[:note_id])
    @note.destroy
    redirect_to :back
  end

#Client search
  def client_search
    if current_user.user_type=="admin"
      @clients=[]
      if !params[:tags].blank?
        client_search_tag(params,@clients)
        @clients=@clients.uniq
        search_tag_result(@clients,params)
      else 
        @clients= current_user.clients
        search_tag_result(@clients,params)
      end
    else  
      user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
      @clients = Client.where(:user_id=>user_type_id)
      search_tag_result(@clients,params)
    end  
  end

#client search method call
  def client_search_tag(params,clients)
    @client=Client.where(:user_id=>current_user)
    @client.each do |client|
      params[:tags].each do |tag|
        if client.tags.collect(&:name).include?tag
          clients << client
        end
      end
    end
  end

#client search method call
  def search_tag_result(clients,params)
    @clients=clients
    if params[:q].blank?
      if params[:sort_by] == "Last Name"
         @clients=@clients.sort_by{ |m| m.last_name.downcase }
      elsif params[:sort_by] == "First Name"
         @clients=@clients.sort_by{ |m| m.first_name.downcase }
      else
        @clients=@clients.sort_by{ |m| m.created_at }.reverse
      end
    else
      search_tag_result_call(params)
    end 
  end

#client search_tag_result_call
  def search_tag_result_call(params)
    params[:q]=params[:q].gsub(/\s+/, "")
    if current_user.user_type=="admin"
      @clients=current_user.clients.where('LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(company_name) LIKE ?', "#{params[:q].downcase}%","#{params[:q].downcase}%","#{params[:q].downcase}%")
    else
      user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
      @clients = Client.where(:user_id=>user_type_id)
      @clients=@clients.where('LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(company_name) LIKE ?', "#{params[:q].downcase}%","#{params[:q].downcase}%","#{params[:q].downcase}%") 
    end 
  end

#Search job client
  def search_job_client
    params[:q]=params[:q].gsub(/\s+/, "")
    @clients=current_user.clients.where('LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(company_name) LIKE ?', "#{params[:q].downcase}%","#{params[:q].downcase}%","#{params[:q].downcase}%")
  end

#search invoice client
  def search_invoice_client
    params[:q]=params[:q].gsub(/\s+/, "")
    @clients=current_user.clients.where('LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(company_name) LIKE ?', "#{params[:q].downcase}%","#{params[:q].downcase}%","#{params[:q].downcase}%")
  end

#create client tag
  def client_tag
    @client=Client.find(params[:client_id])
    @client.tag_list.add(params[:client_tag])
    @client.save
  end

#Search client tag
  def search_tag
    @clients=[]
    @client=Client.where(:user_id=>current_user)
    @client.each do |client|
    if !client.tags.blank?
      if params[:name].blank?
        @clients=Client.where(:user_id=>current_user)
      else
        params[:name].each do |tag|
          if client.tags.collect(&:name).include?tag
            @clients << client
          end
        end
        @clients=@clients.uniq        
      end
    end
    end
  end

#Delete client tag
  def tag_delete
    @client=Client.find(params[:client_id])
    @client.tag_list.remove(params[:name])
    @client.save
  end

#Client image upload in attachment
  def client_image_upload
    @client=Client.find(params[:client_id])
    @note=Note.new(:client_id=>params[:client_id],:note=>params[:note])
    @note.save
    if !params[:file].blank?
      file_upload(params[:file],@note.id)
    end
    redirect_to request.referrer
  end

#Client csv export
  def csv_export
    require 'csv'

    if params[:name]=="{}"
     @clients = Client.where(:user_id=>current_user.id)      
    else
      @clients=[]
      @client = Client.where(:user_id=>current_user.id)
      @client.each do |client|
        if !client.tags.blank? 
          params[:name].split(',').to_a.each do |tag|
            if client.tags.collect(&:name).include?tag
              @clients << client
            end
          end
          @clients=@clients
        end
      end
    end
    csv_string = CSV.generate do |csv|
      csv << ["initial","first_name","last_name","company_name","street1","street2","city","state","zip_code","country","phone_number","user_id","mobile_number", "personal_email"]
        @clients.each do |client|   
          csv_file_download(client,csv)
        end  
     end         
    send_data csv_string,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :disposition => "attachment; filename=clients.csv"
  end

#client vfc export 
  def vfc_export
    require 'vpim/vcard'
    if params[:client_id].nil?
      if params[:name]=="{}"
       @clients = Client.where(:user_id=>current_user.id)
        card=[]
        export_vcard(@clients,card)
        card=card.to_s.gsub("[","")
        card=card.gsub("]","")
        card=card.gsub(",","\n")
        send_data card, :filename => "clients.vcf" 
      else
        @clients=[]
        @client = Client.where(:user_id=>current_user.id)
        @client.each do |client|
          if !client.tags.blank? 
            params[:name].split(',').to_a.each do |tag|
              if client.tags.collect(&:name).include?tag
                @clients << client
              end
            end
            @clients=@clients.uniq
          end
        end
    
        card=[]
        export_vcard(@clients,card)
        card=card.to_s.gsub("[","")
        card=card.gsub("]","")
        card=card.gsub(",","\n")
        send_data card, :filename => "clients.vcf" 
      end
    else
      @client=Client.find(params[:client_id])
      card=Vpim::Vcard::Maker.make2 do |maker|
        maker.add_name do |name|
          name.given = @client.first_name 
          name.family= @client.last_name
        end
        maker.add_addr do |address|
          address.street = @client.try(:street1)  
          address.locality = @client.try(:city)
          address.region = @client.try(:state)
          address.postalcode = @client.try(:zip_code)
          address.country = @client.try(:country)
        end
      end
      send_data card, :filename =>"#{@client.first_name}.vcf"
    end   
  end

#client csv import
  def import_client
    unless params["file"].blank?
      if File.extname(params[:file].original_filename) == ".csv"
        csv_text = File.read(params["file"].tempfile)
        csv = CSV.parse(csv_text, :headers => true)
        client_prop = false
        csv.each_with_index do |row,index|
          if index == 0
            upload_client_csv(row,client_prop)
          else
            client_prop = true if csv[index-1][0] == csv[index][0] && csv[index-1][1] == csv[index][1] && csv[index-1][2] == csv[index][2] && csv[index-1][3] == csv[index][3]
            upload_client_csv(row,client_prop)
          end
        end
        message = "File imported successfully!"
      else
        message = 'File formate not supported!!!'
      end
    end
    respond_to do |format|
      format.html { redirect_to clients_path, notice: message }
      format.json { head :no_content }
    end
  end

  #quick book routes
  def sync_client_to_qb(params)
    customer = Quickbooks::Model::Customer.new
    customer.given_name=client_params[:first_name]
    customer.middle_name=client_params[:last_name]
    customer.company_name=client_params[:company_name]
    address = Quickbooks::Model::PhysicalAddress.new
    address.line1 = client_params[:street1]
    address.line2 = client_params[:street2]
    address.city = client_params[:city]
    address.country_sub_division_code = client_params[:state]
    address.postal_code = client_params[:zip_code]
    customer.billing_address = address
    @vendor_service.create(customer)
  end

#client payment
  def payment
    @client = Client.find(params[:id])
    @payment = @client.payment_invoices.create(payment_invoice_params)
    redirect_to client_path(@client, value: "client_show")
  end

#Demo enteries deactive
  def demo_deactive
    current_user.demo_active =false
    current_user.save
    Client.where(:user_id=>current_user.id,:demo_entry=>false).delete_all
    Property.where(:user_id=>current_user.id,:demo_entry=>false).delete_all
    @quotes=Quote.where(:user_id=>current_user.id,:demo_entry=>false)
    @quotes.each do |quote|
      quote.quote_works.delete_all
    end
    @quotes.delete_all
    @jobs=Job.where(:user_id=>current_user.id,:demo_entry=>false)
    @jobs.each do |job|
      job.job_works.delete_all
    end
    @invoices=current_user.invoices
    @invoices.each do |invoice|
      invoice.invoice_works.delete_all
    end
    @invoices.delete_all
    @job_ids=@jobs.collect(&:id)
    @visits=VisitSchedule.where(:job_id=> @job_ids)
    @visits.delete_all
    @jobs.delete_all
    redirect_to :back
  end

  def new_client
  end

  private

  def file_upload(params,note)
    params.each do |file|
      @attachment=Attachment.new(:image=>file,:note_id=>note)
      @attachment.save
    end
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:initial, :first_name, :last_name, :company_name, :primary_company, :street1, :street2, :city, :state, :zip_code, :country, :personal_email, :mobile_number ,:preference_notification,:phone_number,:email)
    end
    def property_params
      params.require(:client).permit(:street,:street2,:city,:state,:zipcode,:country,:client_id)
    end

    def payment_invoice_params
      params.require(:payment_invoice).permit(:pay_amount, :entry_date, :pay_method,:cheque_number, :transaction_number, :confirmation_number, :additional_note, :transaction_type, :client_id, :user_id )
    end

    def set_qb_service
      oauth_client = OAuth::AccessToken.new($qb_oauth_consumer, session[:token], session[:secret])
      @vendor_service = Quickbooks::Service::Customer.new
      @vendor_service.access_token = oauth_client
      @vendor_service.realm_id = session[:realm_id]
    end

end
