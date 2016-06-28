class CreateCustomCategories < ActiveRecord::Migration
  def change
    create_table :custom_categories do |t|
      t.string :category
      t.string :user_id
      t.string :category_type

      t.timestamps
    end
  end
end
