class CreateJobWorks < ActiveRecord::Migration
  def change
    create_table :job_works do |t|
      t.string :name
      t.text :description
      t.integer :quantity
      t.integer :unit_cost
      t.integer :total
      t.integer :job_id

      t.timestamps
    end
  end
end
