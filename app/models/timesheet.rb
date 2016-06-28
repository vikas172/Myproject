class Timesheet < ActiveRecord::Base

	belongs_to :user
	belongs_to :custom_category
	belongs_to :job
end
