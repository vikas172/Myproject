class CreatePoolServices < ActiveRecord::Migration
  def change
    create_table :pool_services do |t|
			t.string  :ph_low
			t.string  :ph_high
			t.boolean :ph_select
			t.string  :ch_low
			t.string  :ch_high
			t.boolean :ch_select
			t.string  :combined_ch_low
			t.string  :combined_ch_high
			t.boolean :combined_select
			t.string  :alkalinity_low
			t.string  :alkalinity_high
			t.boolean :alkalinity_select
			t.string  :calcium_hardness_low
			t.string  :calcium_hardness_high
			t.boolean :calcium_select
			t.string  :stabilizer_low
			t.string  :stabilizer_high
			t.boolean :stabilizer_select
			t.string  :salt_low
			t.string  :salt_high
			t.boolean :salt_select
			t.string  :dissolved_soild_low
			t.string  :dissolved_soild_high
			t.boolean :dissolved_select
			t.string  :saturation_index_low
			t.string  :saturation_index_high
			t.boolean :saturation_select
			t.integer :user_id
      t.timestamps
    end
  end
end
