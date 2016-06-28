class AddStartWeekOnCompany < ActiveRecord::Migration
  def change
    add_column :companies, :start_week_on, :string
  end
end
