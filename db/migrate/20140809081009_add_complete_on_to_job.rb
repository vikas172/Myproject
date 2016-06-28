class AddCompleteOnToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :complete_on, :date
  end
end
