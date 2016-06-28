class AddSizeDepthToSpaData < ActiveRecord::Migration
  def change
  	add_column :spa_data, :depth, :float
  	add_column :spa_data, :depth2, :float
  	add_column :spa_data, :length, :float
  	add_column :spa_data, :width, :float
  	add_column :spa_data, :width2, :float
  	add_column :spa_data, :diameter, :float
  end
end
