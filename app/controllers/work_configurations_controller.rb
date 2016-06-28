class WorkConfigurationsController < ApplicationController
  include WorkConfigurationsHelper
  before_action :authenticate_user!
	def quote_work_configuration
    @pdf_setting=PdfSetting.new
    @quote_pdf="selected"
	end

	def job_work_configuration
    @job_pdf="selected"
  end

  def invoice_work_configuration
    @team_member=current_user.team_members
    @invoice_default=CustomDefault.find_by_user_id(current_user.id)
    @invoice_pdf="selected"
  end

  def statement_work_configuration
    if !params[:work_configuration].blank? 
      current_user.statement=params[:work_configuration][:statement_contract]
      current_user.statement_order=params[:work_configuration][:statement_sort_order]
      current_user.save
    end  
  end

  def email_option_work_configuration
  end

  def organizer_work_configuration
  end

  def emails
   
    if !Dir.exists?("public/default_emails")
      default_email(params)
    else
      update_email(params)
    end
    redirect_to request.referrer
  end

  # def reset_email_default
  #   redirect_to request.referrer
  # end

  def default_invoice_set
    @invoice_default=CustomDefault.find_by_user_id(current_user.id)
    if @invoice_default.blank?
      @invoice_default=CustomDefault.create(:invoice_default=>params[:work_configuration],:user_id=>current_user.id,:remainder=> params[:remainder],:days=>params[:days],:template=>params[:template])
    else
      @invoice_default.invoice_default=params[:work_configuration]
      @invoice_default.remainder= params[:remainder]
      @invoice_default.days = params[:days]
      @invoice_default.template = params[:template]
      @invoice_default.save
    end
    redirect_to request.referrer
  end

  def mail_to_client
    if session[:mail_by] == "quotes"
      @mailed_obj = Quote.find(params[:id])
      @quote = Quote.find(params[:id])
    elsif session[:mail_by] == "invoices"
      @mailed_obj = Invoice.find(params[:id])
      @invoice = Invoice.find(params[:id])
    end
    @mailed_obj.is_mailed = true
    @mailed_obj.save
    @communication = Communication.new(communication_params)
    @communication.to = params[:communication][:to]
    if @communication.save
      if !params[:communication][:to].first.blank?
        if @invoice.present?
          html = render_to_string(:template => 'invoices/invoice_pdf', :layout => false)
          kit = PDFKit.new(html, :page_size => 'Letter')
          thepdf= kit.to_file("#{Rails.root}/tmp/#{@invoice.id}.pdf")
          UserMailer.mail_to_client(params,thepdf).deliver
          FileUtils.rm_rf("#{Rails.root}/tmp/#{@invoice.id}.pdf")
        else
          html = render_to_string(:template => 'quotes/quote_pdf', :layout => false)
          kit = PDFKit.new(html, :page_size => 'Letter')
          thepdf= kit.to_file("#{Rails.root}/tmp/#{@quote.id}.pdf")
          UserMailer.mail_to_quote(params,thepdf).deliver
          FileUtils.rm_rf("#{Rails.root}/tmp/#{@quote.id}.pdf")
        end
      end
      redirect_to "/#{session[:mail_by]}/#{params[:id]}"
    else
      session[:client_error]= @communication.errors.messages
      redirect_to request.referrer
    end  
  end

  def pdf_settings
    @pdf_setting=PdfSetting.find_by_user_id(current_user.id)
    if @pdf_setting.blank?
      @pdf_setting=PdfSetting.new
      html = render_to_string(:layout => false )
      kit = PDFKit.new(html, :page_size => 'Letter')
      thepdf= kit.to_file("#{Rails.root}/tmp/sig.pdf")
      @pdf_setting.image=thepdf
      @pdf_setting.user_id=current_user.id
      @pdf_setting.save
    else
      pdf_setting_value(params,@pdf_setting)
      @pdf_setting.save
      html = render_to_string(:layout => false )
      kit = PDFKit.new(html, :page_size => 'Letter')
      thepdf= kit.to_file("#{Rails.root}/tmp/sig.pdf")
      @pdf_setting.image=thepdf
      @pdf_setting.save 
    end
    respond_to do |format|
      format.js
    end
  end
  private

    def communication_params
      params.require(:communication).permit(:client_id, :user_id, :sent_date, :to, :cc, :subject, :message, :status, :type, :send_copy, :sent_time, :opened_date)
    end
end

