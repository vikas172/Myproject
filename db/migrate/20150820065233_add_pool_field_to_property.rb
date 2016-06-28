class AddPoolFieldToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :pool_name, :string
    add_column :properties, :pool_activity, :string
    add_column :properties, :pool_type, :string
    add_column :properties, :pool_volume, :string
    add_column :properties, :pool_volume2, :string
    add_column :properties, :pool_gate_code, :string
    add_column :properties, :pool_lifeguards, :integer
    add_column :properties, :pool_notes, :text
  end
end
