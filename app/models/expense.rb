class Expense < ActiveRecord::Base
  belongs_to :user
	belongs_to :job
	# has_attached_file :image
	 has_attached_file :image, :styles => {:thumb => "87x87"},
              :default_url => "/assets/images/file.png",
              :url => "/assets/expenses/:id/:style/:basename.:extension",
              :storage => :s3,
              # :bucket => 'copperservice1',
              # # :s3_credentials => {
              # # :access_key_id => 'AKIAJABVFMLWVFM6RCZQ',
              # # :secret_access_key => '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'
              # # } 

              # :s3_credentials => {
              # :access_key_id => 'AKIAJYLXXQWZS4IWEUOQ',
              # :secret_access_key => '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'
              # } 
              :bucket => 'poolpath',
              # :s3_credentials => {
              # :access_key_id => 'AKIAJABVFMLWVFM6RCZQ',
              # :secret_access_key => '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'
              # } 

              :s3_credentials => {
              :access_key_id => 'AKIAJNWRCORXNZLE7WIA',
              :secret_access_key => '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'
              } 
	validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  after_initialize :init

  def init
    self.cost ||= 0.0
  end

  def self.expenses_report_summary(report)
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
