class AddremainderColumnToCustomDefaults < ActiveRecord::Migration
  def change
  	add_column :custom_defaults, :remainder, :boolean, :default => false
  end
end
