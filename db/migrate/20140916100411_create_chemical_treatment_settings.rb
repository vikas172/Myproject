class CreateChemicalTreatmentSettings < ActiveRecord::Migration
  def change
    create_table :chemical_treatment_settings do |t|
    	t.string   :company_license_no
    	t.text     :users_attributes
    	t.text     :chemicals
    	t.integer  :user_id
      t.timestamps
    end
  end
end
