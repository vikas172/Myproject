class AddFieldDemoEntryToClient < ActiveRecord::Migration
  def change
    add_column :clients, :demo_entry, :boolean, :default => true
    add_column :properties, :demo_entry, :boolean, :default => true
  end
end
