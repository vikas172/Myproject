class AddFieldToUser < ActiveRecord::Migration
  def change
    add_column :users, :company_name, :string
    add_column :users, :full_name, :string
    add_column :users, :phone_number, :integer,:limit=>8
  end
end
