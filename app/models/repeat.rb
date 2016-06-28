class Repeat < ActiveRecord::Base
	serialize :day_holder
	serialize :calender_day
	serialize :calander_week
	belongs_to :job
end
