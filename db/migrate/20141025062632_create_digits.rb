class CreateDigits < ActiveRecord::Migration
  def change
    create_table :digits do |t|
      t.string :name

      t.timestamps
    end
  end
end
