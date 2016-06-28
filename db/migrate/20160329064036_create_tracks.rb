class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :latitude
      t.string :longitude
      t.integer :user_id
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
