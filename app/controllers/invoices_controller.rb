class InvoicesController < ApplicationController
  include InvoicesHelper
  include QuotesHelper
  # skip_before_filter :authenticate_user!, except:[:invoice_payment_show]
  load_and_authorize_resource except:[:create,:invoice_payment_show,:payment_done,:invoice_payment_thanks]
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:invoice_payment_show,:payment_done,:invoice_payment_thanks]
  protect_from_forgery :except =>[:payment_done]




def payment_done
  begin
    customer = Stripe::Customer.create(source: params[:stripeToken])
      rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to invoice_payment_show_url(:amount=>params[:amount])
  end
  charge = Stripe::Charge.create(
       :customer    => customer.id,
       :amount      => (params[:amount].to_f*100).to_i,
       :description => 'Copper service Stripe customer',
       :currency    => 'usd'
     )
   invoice = params[:id]
   @invoice_data = Invoice.find(invoice)
   @invoice_data.status = true
   @invoice_data.save
   if params[:invoice_data]=='static'
     redirect_to :back
   else
    redirect_to invoice_payment_thanks_path
   end
end
  
  # GET /invoices
  # GET /invoices.json
  def index
    @payment_invoice = PaymentInvoice.new
    if current_user.user_type=="user"
      user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
      @clients = Client.where(:user_id=>user_type_id)
      @invoices=Invoice.where(:user_id=>user_type_id)
    else
      @invoices=Invoice.where(:user_id=>current_user.id)
      @clients = Client.where(:user_id=>current_user.id)
    end
  end

  def payment_invoice
    @payment_invoice = PaymentInvoice.new
    if current_user.user_type=="user"
      user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
      @clients = Client.where(:user_id=>user_type_id)
      @invoices=Invoice.where(:user_id=>user_type_id,:mark_sent=>true)
    else
      @invoices=Invoice.where(:user_id=>current_user.id,:mark_sent=>true)
      @clients = Client.where(:user_id=>current_user.id)
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    @attachments=[]
    @notes=@invoice.client.notes
    @notes.each do |note|
      attachment_find(note,@attachments)
    end
    unless session[:send_mail].blank?
      @communication = Communication.new
      @mail_value = @invoice
    end
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Invoices")
    @custom_field_data=@invoice.custom_field if !@invoice.custom_field.blank?
    @invoices = Invoice.where(:user_id=>current_user.id).count
    @payment_invoice = PaymentInvoice.new
  end

  # GET /invoices/new
  def new

    if !params[:quote_id].blank?
      @quote=Quote.find(params[:quote_id])
      @invoice = Invoice.new
      @client= @quote.property.client
      @quote_works = @quote.quote_works
      @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Invoices")
      @services_all=ServiceProduct.where(:user_id == nil|| :user_id== current_user.id)
    else
      @invoices=Invoice.where(:user_id=>current_user.id)
      @services_all=ServiceProduct.where(:user_id == nil|| :user_id== current_user.id)
      @invoice_default=CustomDefault.find_by_user_id(current_user.id)
      @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Invoices")
      @client = Client.find(params[:client_id])
      @invoice = Invoice.new
      @job_works = JobWork.where(job_id: params[:job_ids]) if !params[:job_ids].blank?
      @job_expenses = Expense.where(job_id: params[:job_ids],:exp_billable=>"billable") if !params[:job_ids].blank?
      @job_timesheets = Timesheet.where(job_id: params[:job_ids],:billable=>true) if !params[:job_ids].blank?
    end
  end

  # GET /invoices/1/edit
  def edit
    @services_all=ServiceProduct.where(:user_id == nil|| :user_id== current_user.id)
    @client = @invoice.client
    @custom_field=CustomField.where(:user_id=>current_user.id ,:applies_to=>"Invoices")
    @custom_field_data=@invoice.custom_field if !@invoice.custom_field.blank?
  end

  # POST /invoices
  # POST /invoices.json
  def create
    session[:send_mail] = params[:email_send]
    session[:record_payment] = params[:record_payment]
    session[:mail_by] = "invoices"

    @invoice = Invoice.new(invoice_params)
    @invoice.mark_sent = true if params[:record_payment] == "1"
    @invoice.invoice_paid = true if params[:record_payment] == "1"
    @invoice.client_id=params[:client_id]
    @invoice.quote_id=params[:quote_id] if params[:quote_id]
    if current_user.user_type=="user"
      user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
      @invoice.user_id=user_type_id
    else
    @invoice.user_id=current_user.id
    end
    if !params[:job_ids].blank?
      @invoice.jobs_id= params[:job_ids].split()
    end
    @invoice.custom_field=params[:custom_field]
    respond_to do |format|
      if @invoice.save
        add_work_item_invoice(params,@invoice.id)
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render :index, status: :created, location: @invoice }
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update    
    respond_to do |format|

      if @invoice.update(invoice_params)
        if fetch_past_due(@invoice)
          @invoice.past_due=false
        else
          @invoice.past_due=true
        end
        @invoice.custom_field=params[:custom_field]
        @invoice.save
        if @invoice.invoice_works.first.blank?
          add_work_item_invoice(params,@invoice.id)
        else
          @invoice.invoice_works.first.update(:name=>params[:name],:description=>params[:description],:quantity=>params[:quantity],:unit_cost=>params[:unit_cost],:total=>params[:total])
        end
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

#Display invoice after sorting
  def invoice_sort
    if ((params[:sort_by]=="first_name") || (params[:sort_by]== "last_name"))  
      @invoices=[]
      current_user.clients.order("#{params[:sort_by]} ASC").each do |client|
        client.invoices.each do|invoice|
         @invoices << invoice
        end
      end 
    else
      @invoices = Invoice.where(:user_id=>current_user.id)
    end
  end

#Invoice attachment upload
  def invoice_image_upload
    @invoice=Invoice.find(params[:invoice_id])
    @note=Note.new(:invoice_id=>params[:invoice_id],:note=>params[:note])
    @note.save
    if !params[:file].blank?
      file_upload(params[:file],@note.id)
    end
    redirect_to @invoice
  end

#Invoice sort through time
  def sort_invoice_time
    date = Date.today
    lastMonth = date-1.month
    if params[:sort_by_month] == "last_month"
      @previous=(lastMonth.beginning_of_month..lastMonth.end_of_month)
      sort_month(@previous)
    elsif params[:sort_by_month]== "this_month"
      @previous=(date.beginning_of_month..date.end_of_month)
      sort_month(@previous)
    elsif params[:sort_by_month]== "this_year"
      @previous=(date.beginning_of_year..date.end_of_year)
      sort_month(@previous)
    else
      @invoices = Invoice.where(:user_id=>current_user.id)
    end
  end

#Generate invoice pdf
  def invoice_pdf
    @invoice=Invoice.find(params[:invoice_id])
    html = render_to_string(:layout => false )
    kit = PDFKit.new(html, :page_size => 'Letter')
    send_data(kit.to_pdf, :filename => @invoice.id, :type => 'application/pdf')
  end

#signature through signature paid and store within pdf 
  def invoice_client_sign
    @invoice=Invoice.find(params[:invoice_id])
    instructions = JSON.parse(params[:output]).map { |h| "line #{h['mx'].to_i},#{h['my'].to_i} #{h['lx'].to_i},#{h['ly'].to_i}" } * ' '
    tempfile = Tempfile.new(["signature",".png"], "#{Rails.root.to_s}/tmp/")
    Open3.popen3("convert -size 198x55 xc:transparent -stroke blue -draw @- #{tempfile.path}") do |input, output, error|
        input.puts instructions
    end
    @note=Note.create(:invoice_id=>params[:invoice_id],:note=>params[:note])
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
    redirect_to  @invoice
  end

#Mark sent to the particular invoice
  def mark_sent_invoice
    @invoice=Invoice.find(params[:invoice_id])
    @invoice.mark_sent=true
    if !fetch_past_due(@invoice)
      @invoice.past_due=true
    end
    @invoice.save

    redirect_to @invoice
  end

#Mark invoice as bad debt
  def bad_debt_invoice
    @invoice=Invoice.find(params[:invoice_id]) 
    @invoice.invoice_bad_debt=params[:bad_debt]
    @invoice.save
    redirect_to @invoice
  end

# Invoice payment create
  def invoice_payment_create
    @invoice= Invoice.find(params[:invoice_id])
    @invoice.invoice_paid=true
    @invoice.save
    @invoice_pay=@invoice.payment_invoices.create(payment_invoice_params)
    @invoice_pay.user_id=current_user.id
    @invoice_pay.save
    if request.referrer.include? "payment_invoice"
      redirect_to request.referrer
    else
      redirect_to :back
    end
  end

#Reopen the invoices
  def reopen_invoice
    @invoice=Invoice.find(params[:invoice_id])
    @invoice.invoice_paid=false
    @invoice.save
    redirect_to @invoice
  end

#Sort invoice through its month
  def sort_invoice_outstanding
    if params[:sort_by_month]== "outstanding"
     @invoices = Invoice.where(:user_id=>current_user.id ,:mark_sent=>true,:invoice_paid=>false,:invoice_bad_debt=>false,:past_due=>false)
    elsif params[:sort_by_month] =="draft"
     @invoices = Invoice.where(:user_id=>current_user.id ,:mark_sent=>false)
    elsif params[:sort_by_month]== "paid"
     @invoices = Invoice.where(:user_id=>current_user.id ,:invoice_bad_debt=>false,:invoice_paid=>true)
    elsif params[:sort_by_month]== "bad_debt"
      @invoices = Invoice.where(:user_id=>current_user.id,:mark_sent=>true,:invoice_bad_debt=>true)
    elsif params[:sort_by_month]=="past_due"
       @invoices=Invoice.where(:user_id=>current_user.id,:past_due=>true)
    else
      @invoices = Invoice.where(:user_id=>current_user.id)
    end
  end

#Send invoice email
  def invoice_email_action
    session[:send_mail] = params[:email_send]
    session[:mail_by] = params[:mail_by]
  end
  
  def invoice_payment_show
  end

  def invoice_payment_thanks
  end
  
  private
    def sort_month(month)
      @invoices = Invoice.where(:user_id=>current_user.id, created_at: month)
    end

    def file_upload(params,note)
      params.each do |file|
        @attachment=Attachment.new(:image=>file,:note_id=>note)
        @attachment.save
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      params.require(:invoice).permit(:payment, :subject, :issued_date,:due_date, :tax, :discount_amount, :discount_type, :deposite_amount, :entry_date, :payment_method_type, :payment_method, :additional_note, :client_message, :invoice_order)
    end

    def payment_invoice_params
      params.require(:payment_invoice).permit(:pay_amount, :entry_date, :pay_method,:cheque_number, :transaction_number, :confirmation_number, :additional_note, :transaction_type, :client_id, :user_id )
    end
end
