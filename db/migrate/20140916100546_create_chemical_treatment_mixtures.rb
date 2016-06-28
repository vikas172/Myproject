class CreateChemicalTreatmentMixtures < ActiveRecord::Migration
  def change
    create_table :chemical_treatment_mixtures do |t|
    	t.string :name
    	t.string :targeted_pest
    	t.text 	 :chemicals
    	t.string :concentration
    	t.integer :user_id
      t.timestamps
    end
  end
end
