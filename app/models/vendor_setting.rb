class VendorSetting < ActiveRecord::Base
	belongs_to :user
	serialize :preference_vendor
end
