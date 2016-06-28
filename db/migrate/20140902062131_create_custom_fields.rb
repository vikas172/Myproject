class CreateCustomFields < ActiveRecord::Migration
  def change
    create_table :custom_fields do |t|
      t.string :applies_to
      t.string :name
      t.string :value_type
      t.integer :user_id

      t.timestamps
    end
  end
end
