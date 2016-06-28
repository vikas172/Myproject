class CreateGeneralInfos < ActiveRecord::Migration
  def change
    create_table :general_infos do |t|
      t.integer :default_tax
      t.string :tax_reg_type
      t.string :tax_reg_number
      t.string :country
      t.string :time_zone
      t.string :date_format
      t.string :time_format
      t.string :week_day
      t.integer :user_id

      t.timestamps
    end
  end
end
