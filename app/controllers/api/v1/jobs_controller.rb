class Api::V1::JobsController < Api::V1::ApiController
	skip_before_filter  :verify_authenticity_token
	# before_action :current_user
		require 'open_weather'
	def index
		if !current_user.blank?
			if current_user.user_type=="user"
				user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
				jobs = Job.where(:user_id=>user_type_id)
			else
				jobs = Job.where(:user_id=>current_user.id )
			end
			render :status=>200, :json=>jobs.as_json
		else
			render  :json=>{:status => "Failure Please login" }
		end
	end 

	def show
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					job = Job.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					job = Job.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if job
					render :status=>200, :json=>job.as_json
				else
					render :status=>200, :json=>{:status => "Job not found"}
				end
			else
			  render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
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
				job= Job.new(job_params)
                job.user_id = @user.id
				if job.save
                    start_visit =job.start_date
                    end_visit = job.end_date
					 while(start_visit<=end_visit)
				        visit = job.visit_schedules.new(start_date: start_visit, end_date: start_visit)
				        visit.title= job.description.truncate(20)
				        visit.crew=job.crew
				        visit.event_type="visit"
				        visit.save
				        start_visit += 1
				      end
					render :status=>200, :json=>job.as_json
				else
					render :json=>{:status => "job not save some failure occur"}
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
					job = Job.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					job = Job.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if job
					client= job.property.client
					pool = job.property
				    customer_detail = {:customer_address=>get_pool_detail(pool) ,:customer_email=> client.personal_email,:customer_mobile_number=>client.mobile_number,:first_name=>client.first_name,:last_name=>client.last_name,:pool_details=>get_pool_detail(pool)}
					render :status=>200, :json=>{:job=>job.as_json,:customer_detail=>customer_detail}
				else
					render :status=>200, :json=>{:status => "Job not found"}
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

	def update_job
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					job = Job.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					job = Job.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if job.update(job_params)
					job.visit_schedules.delete_all
					start_visit =job.start_date
                    end_visit = job.end_date
					 while(start_visit<=end_visit)
				        visit = job.visit_schedules.new(start_date: start_visit, end_date: start_visit)
				        visit.title= job.description.truncate(20)
				        visit.crew=job.crew
				        visit.event_type="visit"
				        visit.save
				        start_visit += 1
				      end
					render :status=>200, :json=>job.as_json
				else
					render :status=>200, :json=>{:status => "Job failure occur"}
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
					job = Job.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					job = Job.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if job
					job.destroy
					render :status=>200, :json=>{:status => "Job Deleted sucessfully"}
				else
					render :status=>200, :json=>{:status => "Job not found"}
				end
			else
			  render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end 

	def today_schedule
		if !current_user.blank?
			if current_user.user_type=="user"
				user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
				job = Job.where(:user_id=>user_type_id).collect(&:id)
			else
				job=Job.where(:user_id=>current_user.id).collect(&:id)
			end
			@display_job =[]
			pending_schedule = VisitSchedule.where("start_date < ?",Date.today).where(:job_id=>job,:job_complete=>false)
			today_schedule=VisitSchedule.where(:job_id=> job,:start_date=>Date.today,:job_complete=>false)
			options = { units: "metric", APPID: WEATHER_APPID }
			t_address=[]
			if !today_schedule.blank?
				today_schedule.each do |schedule|
					property = schedule.job.property
					s_address = OpenWeather::Current.city("#{property.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{property.city}, #{property.country}",options)
					# t_address << Geocoder.coordinates("#{property.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{property.city}, #{property.country}")
				  t_address << [s_address["coord"]["lat"], s_address["coord"]["lon"]]
				  @display_job << {:visit_schedule => schedule, :client_first_name=> schedule.job.property.client.first_name, :client_last_name=> schedule.job.property.client.last_name,:client_mobile_number=> schedule.job.property.client.mobile_number,:property_address=>"#{property.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{property.city}, #{property.country}"}
				end
			end
			if !pending_schedule.blank?
				pending_schedule.each do |schedule|
					property = schedule.job.property
					p_address = OpenWeather::Current.city("#{property.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{property.city  rescue ""}, #{property.country  rescue "" }",options)
					# t_address << Geocoder.coordinates("#{property.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{property.city}, #{property.country}")
				  t_address << [p_address["coord"]["lat"], p_address["coord"]["lon"]] rescue "" if !p_address.blank?
				end
			end
		  if !current_user.street.blank?
				# home_address = Geocoder.coordinates("#{current_user.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{current_user.city}, #{current_user.state}, #{current_user.zipcode}")
				h_address = OpenWeather::Current.city("#{current_user.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{current_user.city}, #{current_user.state}, #{current_user.zipcode}",options)
			  home_address = [h_address["coord"]["lat"], h_address["coord"]["lon"]] if !h_address.blank?
			else
				home_address = ""
			end

			if !current_user.company.blank?
				if !current_user.company.street.blank?
					company = current_user.company
					# company_address = Geocoder.coordinates("#{company.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{company.city}, #{company.state}, #{company.zipcode}")
				c_address = OpenWeather::Current.city("#{company.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{company.city}, #{company.state}, #{company.zipcode}",options)
				company_address = [c_address["coord"]["lat"], c_address["coord"]["lon"]]  if !c_address.blank?
				else
					company_address =""
				end
			elsif current_user.user_type == "admin"
				company_address =""
			else
				user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
				user = User.find(user_type_id)
				company=user.company
				if !company.blank?
					if !company.street.blank?
						c_address = OpenWeather::Current.city("#{company.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{company.city}, #{company.state}, #{company.zipcode}",options)
						company_address = [c_address["coord"]["lat"], c_address["coord"]["lon"]] if !c_address.blank?
						# company_address = Geocoder.coordinates("#{company.street.gsub(/[^a-zA-Z0-9\-]/," ") rescue ""}, #{company.city}, #{company.state}, #{company.zipcode}")
					else
						company_address = ""
					end
				else
					company_address =""
				end
			end	
			render :status=>200, :json=>{:today_schedule=>t_address.uniq.compact.as_json,:home_address=>home_address.as_json,:company_address=>company_address.as_json,:job_visit_schedule=>@display_job.as_json}
		else
			render  :json=>{:status => "Failure Please login" }
		end
	end

	def signature_job
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					job = Job.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					job = Job.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if job
					render :status=>200, :json=>job.as_json
				else
					render :status=>200, :json=>{:status => "Job not found"}
				end
			else
			  render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	def close_job
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					@job=Job.find(params[:id])
				else
					@job=Job.find(params[:id])
				end
				if params[:job_status]=="complete"
					  	@job.job_complete=true
					  	@job.job_status= params[:job_status]
					  	@job.job_required= "Require Invoice"
					  	@job.complete_on=Date.today.strftime("%Y/%m/%d")
					  	@job.visit_schedules.update_all(job_complete: true, complete_on: Date.today.strftime("%Y/%m/%d"))
						@job.save
				end
				if @job
					render :status=>200, :json=>@job.as_json
				else
					render :status=>200, :json=>{:status => "Job not found"}
				end
			else
				render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	def job_payment
		if !current_user.blank?
			@job=Job.find(params[:id])
			if @job.job_works.present?
				all_total = @job.job_works
				amount = all_total.collect(&:total).sum
				if (params[:stripeToken].present? && params[:email].present?)
				customer = Stripe::Customer.create(
			      :email => params[:email],
			      :card  => params[:stripeToken]
			    )
			    charge = Stripe::Charge.create(
			      :customer    => customer.id ,
			      :amount      => (amount*100),
			      :description => 'payment-api transaction',
			      :currency    => 'usd'
			    )  rescue ""

			    if !charge.blank?
			    	render  :json=>{:status => "Payment successfully done!" }
		      else
					  render  :json=>{:status => "Something went Wrong, Please try again" }
				  end
				else
					render  :json=>{:status => "Please send email and token" }
				end
			else
				render  :json=>{:status => "No Amount for this job" }	
			end
		else
			render  :json=>{:status => "Failure Please login" }
		end
	end

	def reopen_job
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					@job=Job.find(params[:id])
				else
					@job=Job.find(params[:id])
				end
				@job.job_required = params[:job_required]
				@job.save
				render :status=>200, :json=>@job.as_json
			else
			  render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	def job_invoice
		if !current_user.blank?
		    job = Job.find(params[:id])
		    if job
			    job_works = job.job_works
			    client_id = Job.find(params[:id]).property.client
			    user_id = current_user.id
			    job_id = params[:id].split()
			    if job_works.present?
				    # invoice = Invoice.new(:payment=>"Upon Receipt", :subject=>"For Services Rendered", :jobs_id=>job_id, :user_id=>user_id, :client_id=>client_id,:discount_type=>"$",:deposite_amount=> 0.0)
				    # invoice.save
				    # name_array = []
				    # description_array = []
				    # unit_cost_array = []
				    # total_array = []
				    # job_works.each do |job_work|
				    # 	name_array << job_work.name
				    # 	description_array << job_work.description
				    # 	unit_cost_array << job_work.unit_cost
				    # 	total_array << job_work.total
				    # end
				    # invoice_work = InvoiceWork.new("name"=>name_array,"description"=>description_array,"unit_cost"=>unit_cost_array,"total"=>total_array,"invoice_id"=>invoice.id)
				    # 	invoice_work.save
				    # amount = job_works.collect(&:total).sum
				    #render :status=>200, :json=>{:job => job, :job_works=> job_works, :amount=>amount}
				    render :status=>200, :json=>{:job => job, :job_works=> job_works}
				else
					render :json=>{:status => "Job work are not found"}
				end
			else
				render :json=>{:status => "Job not found"}
			end
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	private
	def job_params
    params.require(:job).permit(:description, :scheduled, :start_date, :end_date, :visits, :start_time, :end_time, :invoicing, :invoice_period, :first_invoice_on,:job_type,:number_of_invoice,:invoice_type, :quote_id, :crew,:job_order,:user_id,:property_id)
  end
  def current_user
  	User.find(params[:user_id]) rescue ""
  end
  def invoice_params
    params.require(:invoice).permit(:payment, :subject, :issued_date,:due_date, :tax, :discount_amount, :discount_type, :deposite_amount, :entry_date, :payment_method_type, :payment_method, :additional_note, :client_message, :invoice_order)
  end


end

