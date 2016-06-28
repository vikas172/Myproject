class AddColumnToChemicalTreatmentMixture < ActiveRecord::Migration
  def change
  	add_column :chemical_treatment_mixtures, :chemical_treatment_setting_id, :integer
  end
end
