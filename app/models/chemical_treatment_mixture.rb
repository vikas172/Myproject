class ChemicalTreatmentMixture < ActiveRecord::Base
	belongs_to :user
	belongs_to :chemical_treatment_settings
end
