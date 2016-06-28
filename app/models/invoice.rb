class Invoice < ActiveRecord::Base
	belongs_to :client
	belongs_to :user
	has_many :invoice_works, :dependent => :destroy
	has_many :notes, :dependent => :destroy
	has_many :payment_invoices , :dependent => :destroy
	serialize :jobs_id
	serialize :custom_field

  def self.get_summary_condition(any,report)
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
end
