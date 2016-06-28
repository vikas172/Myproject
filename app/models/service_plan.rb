class ServicePlan < ActiveRecord::Base
	belongs_to :user
	validates :name, :presence => true
	validates :description, :presence => true
	validates :unit_cost, :presence => true
end
