class Api::V1::QuotesController < Api::V1::ApiController
	skip_before_filter  :verify_authenticity_token


  def index
  	if !current_user.blank?
			if current_user.user_type=="user"
				user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
				quotes = Quote.where(:user_id=>user_type_id)
			else
				quotes = Quote.where(:user_id=>current_user.id )
			end
			 render json:quotes
		else
			render  :json=>{:status => "Failure Please login" }
		end
  end


	def new
	end

	def create
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					@user = User.find(user_type_id)
				else
					@user = current_user
				end
				quote= Quote.new(quote_params)
        quote.user_id = @user.id
				if quote.save
					quote_work=QuoteWork.new(:name=>params[:quote_work].first[:name],:description=>params[:quote_work].first[:description],:quantity=>params[:quote_work].first[:quantity],:unit_cost=>params[:quote_work].first[:unit_cost],:total=>params[:quote_work].first[:total])
					quote_work.quote_id= quote.id
					quote_work.save
					render :status=>200, :json=>{:quote=>quote.as_json,:quote_work=>quote_work.as_json}

				else
					render :json=>{:status => "quote not save some failure occur"}
				end
			else
				render :json=>{:status => "Failure match not found"}
			end		
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	def show
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					quote = Quote.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					quote = Quote.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if quote
					quote_work=quote.quote_works
					render :status=>200, :json=>{:quote=>quote.as_json,:quote_work=>quote_work.as_json}
				else
					render :status=>200, :json=>{:status => "quote not found"}
				end
			else
			  render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end


	def edit
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					quote = Quote.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					quote = Quote.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if quote
					client =  quote.property.client
					pool = quote.property
				  customer_detail = {:customer_address=>get_client_address(client) ,:customer_email=> client.personal_email,:customer_mobile_number=>client.mobile_number,:first_name=>client.first_name,:last_name=>client.last_name,:pool_details=>get_pool_detail(pool)}
					quote_work=quote.quote_works
					render :status=>200, :json=> {:quote_work=>quote_work.as_json,:quote=>quote.as_json,:customer_detail=>customer_detail.as_json}
				else
					render :status=>200, :json=>{:status => "quote not found"}
				end
			else
				render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	def get_pool_detail(pool)
		return "#{pool.street},#{pool.city},#{pool.state},#{pool.zipcode}"
	end
	
	def get_client_address(client)
		if client.street1.blank?
			return ""
		else
			return "#{client.street1}, #{client.city} , #{client.state},#{client.zip_code}"
		end
	end


	def update_quote

		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					quote = Quote.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					quote = Quote.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
	
				if !params[:quote_work].first.blank?
					quote.quote_works.each do |quote_work|
						quote_work[:name]= params[:quote_work].first[:name]
						quote_work[:description]= params[:quote_work].first[:description]
						quote_work[:quantity]= params[:quote_work].first[:quantity]
						quote_work[:unit_cost]= params[:quote_work].first[:unit_cost]
						quote_work[:total]= params[:quote_work].first[:total]
						quote_work.save
					end
				end
				if quote.update(quote_params)
					render :status=>200, :json=>{:quote=>quote.as_json,:quote_work=>quote.quote_works.as_json}
				else
					render :status=>200, :json=>{:status => "quote failure occur"}
				end
			else
				render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	def destroy
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					quote = Quote.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					quote = Quote.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if quote
					quote.quote_works.delete_all
					quote.destroy
					render :status=>200, :json=>{:status => "quote Deleted sucessfully"}
				else
					render :status=>200, :json=>{:status => "quote not found"}
				end
			else
			  render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end
    def find_quote
    	if !current_user.blank?
    		quote_id = params[:id].to_i
    		@quote = Quote.find(quote_id)
    		  
    		if @quote
				render :status=>200, :json=>@quote.as_json
			else
				render :status=>200, :json=>{:status => "quote not found"}
			end
		else
			render :json=>{:status => "Failure Please login"}
		end
    end
    def signature_quote
        if !current_user.blank?
	        note = Note.new(:quote_id=>params[:id])
	        if note.save 
	       	 	attachment = Attachment.new(:image=>params[:image],:note_id=>note.id)
	       		if attachment.save
					@quote = Quote.find(params[:id])
					# tempfile = open(attachment.image.url)
					FileUtils.mkdir_p "#{Rails.public_path}/quote_attachment"
					# @upload = File.open(Rails.root.join('public/quote_attachment',"#{current_user.id}.png"), 'w') do |file|
			    	#tempfile.to_s.encode('UTF-8', {:invalid => :replace,:undef   => :replace,:replace => '?'})
				    #file.write(tempfile.read)
				    #end 
					# tempfile = open(attachment.image.path)
					# FileUtils.mkdir_p "#{Rails.public_path}/quote_attachment"
				 	# @upload = File.open(Rails.root.join('public/quote_attachment',"#{current_user.id}.png"), 'w') do |file|
				 	# file.write(tempfile.read)
				 	# end    
					html = render_to_string(:layout => false )
				    kit = PDFKit.new(html, :page_size => 'Letter')
	 				thepdf= kit.to_file("#{Rails.root}/tmp/signature.pdf")
	 				#thepdf = (kit.to_pdf, :type => 'application/pdf')
				    attachment.image=  thepdf
	    			attachment.save
				    # send_data(kit.to_pdf, :filename => @quote.id, :type => 'application/pdf')
	       			render :status=>200, :json=>attachment.as_json
	       		else
	       			render :json=>{:status => "something went wrong in attachment image"}
	       		end
	       	else
	       		render :json=>{:status => "something went wrong in note"}
	       	end
        else
		  render :json=>{:status => "Failure Please login"}
	    end
    end

    def quotes_image
    	if !current_user.blank?
    		quote = Quote.find(params[:id])
    		pdf_url = quote.notes.last.attachments.last.image.url rescue ""
    		render :status=>200, :json=>{:url=>pdf_url}
    	else
		  render :json=>{:status => "Failure Please login"}
	    end
    end

    def quote_image_save
    	if !current_user.blank?
    		quote = Quote.find(params[:id])
    		attachment = quote.notes.last.attachments.last
    		attachment.update(:image=>params[:image])
    		render  :json=>{:status => "upload signature" }
    	else
		  render :json=>{:status => "Failure Please login"}
	    end
    end

	private
	def quote_params
    params.require(:quote).permit(:tax, :discount, :discount_type, :require_deposit, :require_deposit_type, :client_message, :quote_order,:property_id,:raty_score)
  end
  
  def current_user
  	User.find(params[:user_id]) rescue ""
  end
end