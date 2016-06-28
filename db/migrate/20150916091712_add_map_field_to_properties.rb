class AddMapFieldToProperties < ActiveRecord::Migration
  def change
  	add_column :properties ,:estimate_map ,:string
  end
end
