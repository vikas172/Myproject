class ServiceReminder < ActiveRecord::Base
	serialize  :subscribed_user
	belongs_to :user
end
