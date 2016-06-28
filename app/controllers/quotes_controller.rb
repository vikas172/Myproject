class QuotesController < ApplicationController
  include QuotesHelper
  include ApplicationHelper
  load_and_authorize_resource except:[:create]
  before_action :authenticate_user!
  before_action :set_quote, only: [:show, :edit, :update, :destroy]
  
  # GET /quotes
  # GET /quotes.json
  def index
    if current_user.user_type=="user"
      if set_view_permission_for_work_client_property(current_user.permission.permission_quotes)
        user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
        @clients = Client.where(:user_id=>user_type_id)
        @quotes = Quote.where(:user_id=>user_type_id)
      elsif set_view_permission_for_work_client_property(current_user.permission.permission_jobs)
        redirect_to jobs_path
      elsif set_view_permission_for_work_client_property(current_user.permission.permission_invoices)
        redirect_to invoices_path
      end              
    else
      @quotes = Quote.where(:user_id=>current_user.id)
      @clients = Client.where(:user_id=>current_user.id)
    end
  end

#service production get
  def item_service_description
    @service=ServiceProduct.find_by_name(params[:service_name])
  end

  # GET /quotes/1
  # GET /quotes/1.json
  def show
    @attachments=[]
    @notes=@quote.property.client.notes
    @notes.each do |note|
      attachment_find(note,@attachments)
    end
    unless session[:send_mail].blank?
      @communication = Communication.new
      @mail_value = @quote.property
    end
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Quotes")
    @custom_field_data=@quote.custom_field if !@quote.custom_field.blank?
    @quotes=Quote.where(:user_id=>current_user.id).count
    @quote_job = Job.where(quote_id: @quote.id)
  end

  # GET /quotes/new
  def new
    @quotes=Quote.where(:user_id=>current_user.id)
    @services_all=ServiceProduct.where(:user_id == nil|| :user_id== current_user.id)
   @service_products=[]
   @services_all.each do |ser_pro|
    @service_products << { id: ser_pro.id.to_s, value: ser_pro.name, description:ser_pro.description, unit_cost:ser_pro.unit_cost}
   end
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Quotes")
    @client = Client.find(params[:client_id]) unless params[:client_id].blank?
    quotes_new_urls(params)
  end

  # GET /quotes/1/edit
  def edit
    @property=@quote.property
    @services_all=ServiceProduct.where(:user_id == nil|| :user_id== current_user.id)
    @custom_field_data=@quote.custom_field if !@quote.custom_field.blank?
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Quotes")
  end

  # POST /quotes
  # POST /quotes.json
  def create
    session[:send_mail] = params[:email_send]
    session[:mail_by] = "quotes"
    @quote = Quote.new(quote_params)
    quote_add(params,@quote)
    @quote.custom_field=params[:custom_field]

    if @quote.save
      add_work_item(params,@quote.id)
      if params[:convert_to_job] == "1"
        redirect_to new_job_path(:quote_id=>@quote.id, :client_id=>@quote.property.client.id, :property_id=>@quote.property.id) 
      else
        respond_to do |format|
          format.html { redirect_to @quote, notice: 'Quote was successfully created.' }
          format.json { render :show, status: :created, location: @quote }
        end
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotes/1
  # PATCH/PUT /quotes/1.json
  def update
    respond_to do |format|
      if @quote.update(quote_params)
        @quote.custom_field=params[:custom_field]
        @quote.save
        @quote.update(:raty_score=>params[:score])
        add_work_item(params,@quote.id) if @quote.quote_works.blank?
        @quote.quote_works.first.update(:name=>params[:name],:description=>params[:description],:quantity=>params[:quantity],:unit_cost=>params[:unit_cost],:total=>params[:total]) if !@quote.quote_works.blank?
        format.html { redirect_to @quote, notice: 'Quote was successfully updated.' }
        format.json { render :show, status: :ok, location: @quote }
      else
        format.html { render :edit }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1
  # DELETE /quotes/1.json
  def destroy
    @quote.destroy
    respond_to do |format|
      format.html { redirect_to quotes_url, notice: 'Quote was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

#search client in a list
  def search_quote_client
    params[:q]=params[:q].gsub(/\s+/, "")
    @clients=current_user.clients.where('LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(company_name) LIKE ?', "#{params[:q].downcase}%","#{params[:q].downcase}%","#{params[:q].downcase}%")
  end

#select list property where user select property and create quotes
  def property_select
    @client=Client.find(params[:client_id])
    @client_properties=@client.properties
  end

  def add_work_quote
  end

#Sort quote by first name and last name
  def quote_sort
    if ((params[:sort_by]=="first_name")|| (params[:sort_by]=="last_name"))
      @quotes=[]
      current_user.clients.order("#{params[:sort_by]} ASC").each do |client|
        client.properties.each do |property|
          property.quotes.each do |quote|
            @quotes << quote
          end
        end
      end
    elsif params[:sort_by]=="star_rating" 
      @quotes=Quote.where(:user_id=>current_user.id).order("raty_score DESC")
    else
      @quotes=Quote.where(:user_id=>current_user.id)
    end    
  end
  
#image upload on the attachment
  def quote_image_upload
    @quote=Quote.find(params[:quote_id])
    @note=Note.new(:quote_id=>params[:quote_id],:note=>params[:note])
    @note.save
    if !params[:file].blank?
      if !params[:file].first.blank?
        file_upload(params[:file],@note.id)
      end
    end
    redirect_to @quote
  end

#sort quotes by its months
  def sort_by_time
    if params[:sort_by_month] == "last_month"
      @previous=(Time.now-1.month).month
      sort_month(@previous)
    elsif params[:sort_by_month]== "this_month"
      @previous=(Time.now).month
      sort_month(@previous)
    elsif params[:sort_by_month]== "this_year"
      @previous=(Time.now).year
      sort_year(@previous)
    else
      @quotes = Quote.where(:user_id=>current_user.id)
    end
  end

#generate quote pdf
  def quote_pdf
    @quote=Quote.find(params[:id])
    html = render_to_string(:layout => false )
    kit = PDFKit.new(html, :page_size => 'Letter')
    send_data(kit.to_pdf, :filename => @quote.id, :type => 'application/pdf')
  end

#generate blank pdf
  def blank_quote
    html = render_to_string(:layout => false )
    kit = PDFKit.new(html, :page_size => 'Letter')
    send_data(kit.to_pdf, :filename => "blank_quote", :type => 'application/pdf')
  end

#select clients
  def client_select
    @quotes = Quote.where(:user_id=>current_user.id)
    @clients = Client.where(:user_id=>current_user.id)
  end

#update quote sent
  def quote_sent
    @quote=Quote.find(params[:quote_id])
    @quote.sent=true
    @quote.save
    redirect_to @quote
  end

#update quotes archive
  def quote_archive
    @quote=Quote.find(params[:quote_id])
    if (params[:archive]=="true")
      @quote.archive=true
    else
      @quote.archive=false
    end
    @quote.save
    redirect_to @quote
  end

#quotes sort by its type
  def quote_sort_archive
    if  params[:sort_by]=="draft"
      @quotes= Quote.where(:user_id=>current_user.id,:sent=>false)
    elsif params[:sort_by]=="sent"
      @quotes= Quote.where(:user_id=>current_user.id,:sent=>true,:archive=>false)
    elsif params[:sort_by]=="archived"
      @quotes= Quote.where(:user_id=>current_user.id,:sent=>true,:archive=>true)
    else
      @quotes= Quote.where(:user_id=>current_user.id)
    end
  end

#quotes create sign and append on the pdf
  def quote_client_sign
    @quote=Quote.find(params[:quote_id])
    instructions = JSON.parse(params[:output]).map { |h| "line #{h['mx'].to_i},#{h['my'].to_i} #{h['lx'].to_i},#{h['ly'].to_i}" } * ' '
    tempfile = Tempfile.new(["signature",".png"], "#{Rails.root.to_s}/tmp/")
    Open3.popen3("convert -size 198x55 xc:transparent -stroke blue -draw @- #{tempfile.path}") do |input, output, error|
      input.puts instructions
    end
    @note=Note.create(:quote_id=>params[:quote_id],:note=>params[:note])
    @note.attachments.create(:image=>tempfile)

    FileUtils.mkdir_p "#{Rails.public_path}/signature"
      @upload = File.open(Rails.root.join('public/signature',"#{current_user.id}.png"), 'w') do |file|
      file.write(tempfile.read)
    end

    html = render_to_string(:layout => false )
    kit = PDFKit.new(html, :page_size => 'Letter')
    @attach=@note.attachments.last
    
    thepdf= kit.to_file("#{Rails.root}/tmp/signature.pdf")
    @attach.image=thepdf
    @attach.save
    FileUtils.rm_rf("#{Rails.public_path}/signature/#{current_user.id}.png")
    redirect_to  @quote
  end

#save button email send option also be their
  def email_action
    session[:send_mail] = params[:email_send]
    session[:mail_by] = params[:mail_by]
  end

  private

  def quote_add(params,quote)
    quote.property_id = params[:property_id]
    quote.raty_score=params[:score]
    if current_user.user_type=="user"
      user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
      quote.user_id = user_type_id
    else
      quote.user_id=current_user.id
    end
  end

  def sort_month(month)
    @quotes=[]
    @quote = Quote.where(:user_id=>current_user.id)
    @quote.each do |quote|
      if (quote.created_at.strftime("%m").to_i==month)
        @quotes << quote
      end
    end
  end

  def file_upload(params,note)
    params.each do |file|
      @attachment=Attachment.new(:image=>file,:note_id=>note)
      @attachment.save
    end
  end

  def sort_year(year)
    @quotes=[]
    @quote = Quote.where(:user_id=>current_user.id)
    @quote.each do |quote|
      if (quote.created_at.strftime("%Y").to_i==year)
        @quotes << quote
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_quote
    @quote = Quote.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def quote_params
    params.require(:quote).permit(:tax, :discount, :discount_type, :require_deposit, :require_deposit_type, :client_message, :quote_order)
  end
end
