class TeamMember < ActiveRecord::Base
	belongs_to :user
	has_one :permission, :dependent => :destroy
	serialize :custom_field
	validates :full_name, :presence => true
	validates :email, :presence => true
	validates :mobile_number, :presence => true
	validates_email_format_of :email, :message => 'is not looking good'
	
end
