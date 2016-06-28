class Job < ActiveRecord::Base
	belongs_to :property
	belongs_to :user
	has_one :repeat
	has_many :notes, :dependent => :destroy
	has_many :job_works, :dependent => :destroy
	has_many :visit_schedules, :dependent=>:destroy
	has_one :timesheet, :dependent=>:destroy
	has_one :expense, :dependent=>:destroy
	serialize :crew
	serialize :custom_field
	# accepts_nested_attributes_for :job_works

	#get total amount, invoice and  items added 
	def get_job_total(job_id)
		@invoices = Invoice.all
		invoice_total =0
		@invoices.each do |invoice|
			unless invoice.jobs_id.blank?
				if invoice.jobs_id.include?("#{job_id}")
					@job_total = JobWork.where(job_id: job_id).pluck(:total).sum 
					@invoice_work = InvoiceWork.where(invoice_id: invoice.id)
					@invoice_work.first.total.each do |p|
						invoice_total = invoice_total+p.to_f
					end
				end
			end
		end 
		return @job_total.to_f+invoice_total.to_f
	end

	#check for invoice present for job
	def invoice_present(job_id)
		Invoice.all.pluck(:jobs_id).flatten.include?(job_id)
	end

	#get job works total
	def job_work_total(job_id)
		@job_work_total = Job.find(job_id).job_works
	end

	#Get data according to date
  def self.quotes_report_summary(report)
    date = Date.today
    week_begin = date.at_beginning_of_week
    week_end = date.at_end_of_week
    month_begin = date.at_beginning_of_month
    month_end = date.at_end_of_month
    year_begin = date.at_beginning_of_year
    year_end = date.at_end_of_year
    last12month = (Date.today - 1.year)
    unless report.blank?
	    if report[:range] == "week"
	      condition = where(['DATE(created_at) >= DATE(?) AND DATE(created_at) <= DATE(?)',week_begin, week_end])
	    elsif report[:range] == "month"
	      condition = where(['DATE(created_at) >= DATE(?) AND DATE(created_at) <= DATE(?)',month_begin, month_end])
	    elsif report[:range] == "calendar_year"
	      condition = where(['DATE(created_at) >= DATE(?) AND DATE(created_at) <= DATE(?)',year_begin, year_end])
	    elsif report[:range] == "custom" && !report[:start_date].blank? && !report[:end_date].blank?
	      condition = where(['DATE(created_at) >= DATE(?) AND DATE(created_at) <= DATE(?)',report[:start_date], report[:end_date]])
	    else
	      condition = where(['DATE(created_at) >= DATE(?) AND DATE(created_at) <= DATE(?)',last12month, Date.today.to_date ])
	    end
	  else
	  	condition = where(['DATE(created_at) >= DATE(?) AND DATE(created_at) <= DATE(?)',last12month, Date.today.to_date ])
	  end
  end

  def get_crew_member(user_id)
  	@user=User.find(user_id)
  end

  def self.import(file)
		file = File.open(file.path)
		csv = CSV.parse(file, :headers => true)
		csv.each do |row|
			Job.create! row.to_hash
		end
	end
end
