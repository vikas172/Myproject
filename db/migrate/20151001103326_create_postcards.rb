class CreatePostcards < ActiveRecord::Migration
  def change
    create_table :postcards do |t|
      t.string :from_name
      t.string :from_street
      t.string :from_city
      t.string :from_state
      t.string :from_zipcde
      t.string :from_country
      t.string :to_name
      t.string :to_street
      t.string :to_city
      t.string :to_state
      t.string :to_zipcode
      t.string :to_country
      t.text :message
      t.integer :user_id 

      t.timestamps
    end
  end
end
