class Phone < ActiveRecord::Base
	belongs_to :client
	serialize :phone_initial
	serialize :phone_number
	serialize :primary_phone
end
