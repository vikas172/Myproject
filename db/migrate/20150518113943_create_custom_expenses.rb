class CreateCustomExpenses < ActiveRecord::Migration
  def change
    create_table :custom_expenses do |t|
      t.float :mileage
      t.float :km
      t.integer :user_id

      t.timestamps
    end
  end
end
