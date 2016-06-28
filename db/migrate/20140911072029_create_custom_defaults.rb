class CreateCustomDefaults < ActiveRecord::Migration
  def change
    create_table :custom_defaults do |t|
      t.text :invoice_default
      t.integer :user_id

      t.timestamps
    end
  end
end
