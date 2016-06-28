class Email < ActiveRecord::Base
	belongs_to :client
	serialize :email_initial
	serialize :email
	serialize :primary_email
	
end
