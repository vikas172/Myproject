class Client < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  acts_as_taggable_on :client_tag
	has_many :properties, :dependent => :destroy
	has_many :phones, :dependent => :destroy
	has_many :emails, :dependent => :destroy
	belongs_to :user
	has_many :invoices, :dependent => :destroy
	has_many :notes, :dependent => :destroy
	has_many :payment_invoices, :dependent => :destroy
	has_many :communications, :dependent => :destroy
	serialize :custom_field
  # validates :first_name,:last_name,:company_name,:street1,:street2,:city,:state,:country, presence: true
  validates :first_name, :presence => true
	validates :last_name, :presence => true
	validates :company_name, :presence => true
	validates :mobile_number, :presence => true
	validates :personal_email, :presence => true

  # validates_length_of :zip_code, maximum: 6
	validates_email_format_of :personal_email, :message => 'is not looking good'
	#Get data according to date
  def self.clients_balance_summary(report)
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


	def self.import(file)
		file = File.open(file.path)
		csv = CSV.parse(file, :headers => true)
		csv.each do |row|
			Client.create! row.to_hash
		end
	end
end
