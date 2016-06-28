class AddDemoEnteryToWorkOrder < ActiveRecord::Migration
  def change
    add_column :quotes, :demo_entry, :boolean, :default => true
    add_column :jobs, :demo_entry, :boolean, :default => true
    add_column :invoices, :demo_entry, :boolean, :default => true
  end
end
