class AddFieldsToGeneralInfo < ActiveRecord::Migration
  def change
  	add_column :general_infos, :street1, :string
  	add_column :general_infos, :street2, :string
  	add_column :general_infos, :city, :string
  	add_column :general_infos, :state, :string
  	add_column :general_infos, :company_phone, :string
  end
end
