class Api::V1::InvoicesController < Api::V1::ApiController
	skip_before_filter  :verify_authenticity_token


  def index
  	if !current_user.blank?
			if current_user.user_type=="user"
				user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
				invoices = Invoice.where(:user_id=>user_type_id)
			else
				invoices = Invoice.where(:user_id=>current_user.id )
			end
			render :status=>200, :json=>invoices.as_json
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
				invoice= Invoice.new(invoice_params)
                invoice.user_id = @user.id
				if invoice.save
				   invoice_work=InvoiceWork.new(:name=>params[:name],:description=>params[:description],:quantity=>params[:quantity],:unit_cost=>params[:unit_cost],:total=>params[:total],:invoice_id=>invoice.id)
		           invoice_work.save
				   #render :status=>200, :json=>invoice.as_json
				   render :status=>200,:json=>{:invoice => invoice, :invoice_work=> invoice_work}
				else
					render :json=>{:status => "invoice not save some failure occur"}
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
					invoice = Invoice.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					invoice = Invoice.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if invoice
					render :status=>200, :json=>invoice.as_json
				else
					render :status=>200, :json=>{:status => "invoice not found"}
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
					invoice = Invoice.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					invoice = Invoice.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if invoice
					client= invoice.client
				  customer_detail = {:customer_address=>get_client_address(client) ,:customer_email=> client.personal_email,:customer_mobile_number=>client.mobile_number,:first_name=>client.first_name,:last_name=>client.last_name}
					render :status=>200, :json=>{invoice: invoice.as_json, customer_detail: customer_detail.as_json}
				else
					render :status=>200, :json=>{:status => "invoice not found"}
				end
			else
				render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end
	
	def get_client_address(client)
		if client.street1.blank?
			return ""
		else
			return "#{client.street1}, #{client.city} , #{client.state},#{client.zip_code}"
		end
	end

	def update_invoice
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					invoice = Invoice.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					invoice = Invoice.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if invoice.update(invoice_params)
					render :status=>200, :json=>invoice.as_json
				else
					render :status=>200, :json=>{:status => "invoice failure occur"}
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
					invoice = Invoice.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					invoice = Invoice.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if invoice
					invoice.destroy
					render :status=>200, :json=>{:status => "invoice Deleted sucessfully"}
				else
					render :status=>200, :json=>{:status => "invoice not found"}
				end
			else
			  render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	private
    def invoice_params
      params.require(:invoice).permit(:payment, :subject, :issued_date,:client_id,:due_date, :tax, :discount_amount, :discount_type, :deposite_amount, :entry_date, :payment_method_type, :payment_method, :additional_note, :client_message, :invoice_order,:user_id)
    end

	  def current_user
	  	User.find(params[:user_id]) rescue ""
	  end
end