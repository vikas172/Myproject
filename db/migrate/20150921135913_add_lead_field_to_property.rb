class AddLeadFieldToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :lead, :boolean, :default => false
  end
end
