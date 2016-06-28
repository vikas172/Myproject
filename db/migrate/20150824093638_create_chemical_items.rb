class CreateChemicalItems < ActiveRecord::Migration
  def change
    create_table :chemical_items do |t|
      t.boolean :liquid_chlorine_select, :default => true
      t.string :liquid_chlorine_gal
      t.boolean :di_chlor_select
      t.string :di_chlor_ib
      t.boolean :tri_chlor_select
      t.string :tri_chlor_ib
      t.boolean :muriatic_acid_select
      t.string :muriatic_acid_gal
      t.boolean :dry_muriatic_acid_select
      t.string :dry_muriatic_acid_lb
      t.boolean :bromine_tans_select
      t.string :bromine_tans
      t.boolean :soda_ash_select
      t.string :soda_ash_lb
      t.boolean :sodium_bicarbonate_select, :default => true
      t.string :sodium_bicarbonate_lb
      t.boolean :salt_bags_select
      t.string :salt_bags
      t.boolean :water_clarifier_select, :default => true
      t.string :water_clarifier_oz
      t.boolean :algacide_oz_select
      t.string :algacide_oz
      t.boolean :phosphate_remover_select, :default => true
      t.string :phosphate_remover
      t.integer :property_id
      t.string  :date
      t.string  :source
      t.integer :user_id
      t.timestamps
    end
  end
end
