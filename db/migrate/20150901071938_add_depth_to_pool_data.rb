class AddDepthToPoolData < ActiveRecord::Migration
  def change
  	add_column :pool_data, :depth, :float
  	add_column :pool_data, :depth2, :float
  	add_column :pool_data, :length, :float
  	add_column :pool_data, :width, :float
  	add_column :pool_data, :width2, :float
  	add_column :pool_data, :diameter, :float
  end
end
