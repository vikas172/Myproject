class GeneralInfo < ActiveRecord::Base
	belongs_to :user
	serialize :week_day
	COUNTRY={"US"=>"+1", "IN"=>"+91"}
end
