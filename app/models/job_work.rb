class JobWork < ActiveRecord::Base
	belongs_to :job

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
end
