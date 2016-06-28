module QuotesHelper
	def add_work_item(params,quote)
		@quote_work=QuoteWork.new(:name=>params[:name],:description=>params[:description],:quantity=>params[:quantity],:unit_cost=>params[:unit_cost],:total=>params[:total],:quote_id=>quote)
		@quote_work.save
	end

	def total_amount(quote)
	 @total=quote.quote_works.first.try(:total)
	  if !@total.blank?
	  	@total_all=0
	  	quote.quote_works.first.try(:total).each do |total|
	  		@total_all= @total_all + total.to_f
	  	end	
	  	if !quote.discount.nil?
	  		@total_all=(@total_all - quote.discount).to_f
	  	end
	  	if !quote.tax.nil?
	  		@tax = number_with_precision((@total_all*quote.tax)/100,:precision => 2).to_f
	  		@total_all=(@total_all+@tax).to_f
	  	end
	  	@total_all
	  else
	  	@total_all=0
	  end
	end

	def show_tax(quote,total_value)
		@quote=quote
		@total_value=total_value
			if !@quote.discount.nil?
	      @tax_calculate= @total_value - @quote.discount rescue 0
	    else
	    	@tax_calculate= @total_value
	    end  
      
			if !@quote.tax.nil?
	    	@tax=(((@tax_calculate)*(@quote.tax))/100).to_f rescue 0
	    else
	    	@tax = 0.00
	    end
	end

	def property_quote_client(params)
		property=Property.find(params[:property_id])
		return property.client.try(:initial)+" "+ property.client.try(:first_name)+" "+property.client.try(:last_name) rescue ""
	end

	def property_client_quote(property)

		property=Property.find(property)
		return property.client.try(:initial)+" "+ property.client.try(:first_name)+" "+property.client.try(:last_name) rescue ""
	end

	def quote_client_lfname(quote)
		return quote.property.client.try(:last_name)+" "+quote.property.client.try(:first_name)+" "+ quote.property.client.try(:initial) 
	end

	def quote_client_flname(quote)
		return quote.property.client.try(:initial)+" "+ quote.property.client.try(:first_name)+" "+quote.property.client.try(:last_name) rescue ""
	end

	def client_name_display(client)
		return client.try(:initial)  +" "+ client.try(:first_name) +" "+ client.try(:last_name)   +" ("+ client.try(:company_name) +")" 
	end

	#Calculate quotes data value
  def get_quotes_report_data(status)
  	@quotes_condition = Quote.where(:user_id => current_user.id)
    if status.blank?
      @quote = @quotes_condition
    elsif status == "draft"
      @quote = @quotes_condition.where(sent: false)
    elsif status == "pending"
      @quote = @quotes_condition.where(sent: true, archive: false)
    elsif status == "sent"
      @quote = @quotes_condition.where(sent: true)
    elsif status == "won"
    	arr_id = []
      Job.all.each{|p| arr_id << p.quote_id unless p.quote_id.blank? }
      @quote = @quotes_condition.where(id: arr_id)
    end
		@quote_status_total = 0
		quote_total = 0
		unless @quote.blank?
			@quote.each do |quote|
        @quote_work = QuoteWork.where(quote_id: quote.id).first
        unless @quote_work.blank?
  				@quote_work.total.each do |p|
  					quote_total = quote_total + p.to_f
  				end
        end
			end
		end
		return @quote_status_total+quote_total
  end

  #quotes count
  def get_count_quotes(type)
  	@quotes_condition = Quote.where(:user_id => current_user.id)
    if type.blank?
      @quote = @quotes_condition.count
    elsif type == "draft"
      @quote = @quotes_condition.where(sent: false).count
    elsif type == "pending"
      @quote = @quotes_condition.where(sent: false, archive: false).count
    elsif type == "sent"
      @quote = @quotes_condition.where(sent: true).count
    elsif type == "won"
    	arr_id = []
      Job.all.each{|p| arr_id << p.quote_id unless p.quote_id.blank? }
      @quote = @quotes_condition.where(id: arr_id).count
    end
  end

  #quotes status for won quote
  def quote_status(quote)
  	return Job.all.pluck(:quote_id).include? quote.id
  end


  private

  def quotes_new_urls(params)
  	if params[:client_id].blank? 
      if !params[:property_id].blank?
        @property=Property.find(params[:property_id])
       end
      @quote = Quote.new
    elsif !params[:property_id].blank? 
       @property=Property.find(params[:property_id])
       @quote = Quote.new
    else
      @client_property=Client.find(params[:client_id]).properties
        if @client_property.count == 1
          @quote = Quote.new
          @property_id=@client_property.first.id
          @property=Property.find(@client_property.first.id)
        elsif @client_property.count == 0
          if params[:work]=="work"
            redirect_to new_property_path(:client_id=>params[:client_id],:quote_create=>params[:quote_create],:work=>params[:work])
          elsif params[:value]=="client_show" && params[:quote_create]!="quote"
            redirect_to new_property_path(:client_id=>params[:client_id],:value=>params[:value])
          elsif params[:quote_create]=="quote"
            redirect_to new_property_path(:client_id=>params[:client_id],:quote_create=>params[:quote_create])            
          else
            redirect_to new_property_path(:client_id=>params[:client_id],:quote_create=>params[:quote_create])
          end
        else
        redirect_to property_select_path(:client_id=>params[:client_id])
      end
    end
  end

  #get link for job useed quotes
  def attachment_find(note, attachment)
    if !note.attachments.blank?
      note.attachments.each do |attach|
        attachment << attach
      end
    end  
  end
end
