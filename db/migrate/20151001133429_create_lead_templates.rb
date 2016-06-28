class CreateLeadTemplates < ActiveRecord::Migration
  def change
    create_table :lead_templates do |t|
      t.text :content
      t.integer :user_id

      t.timestamps
    end
  end
end
