class AddZipCodeFieldToGeneralInfo < ActiveRecord::Migration
  def change
    add_column :general_infos, :zipcode, :string
    add_column :general_infos, :service_tax, :string
  end
end
