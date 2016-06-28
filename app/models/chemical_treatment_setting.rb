class ChemicalTreatmentSetting < ActiveRecord::Base
	has_many :chemical_treatment_mixtures, :dependent => :destroy
	belongs_to :user
	serialize :chemicals
	serialize :users_attributes
end
