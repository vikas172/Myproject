class AddFieldToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :client_id, :integer
  end
end
