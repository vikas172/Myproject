class AddColumnToCharge < ActiveRecord::Migration
  def change
  	add_column :charges, :addon_amount, :integer, default: 0
  	add_column :charges, :addons_id, :string
  	add_column :charges, :active_date, :date
  end
end
