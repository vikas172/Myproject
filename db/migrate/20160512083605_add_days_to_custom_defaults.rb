class AddDaysToCustomDefaults < ActiveRecord::Migration
  def change
  	add_column :custom_defaults, :days, :integer
    add_column :custom_defaults, :template, :text
  end
end
