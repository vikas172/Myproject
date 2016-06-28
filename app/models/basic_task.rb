class BasicTask < ActiveRecord::Base
	belongs_to :user
	belongs_to :property
	serialize :assigned_to
end
