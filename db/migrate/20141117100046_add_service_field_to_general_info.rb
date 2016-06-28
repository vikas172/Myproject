class AddServiceFieldToGeneralInfo < ActiveRecord::Migration
  def change
    add_column :general_infos, :service_number, :string
    add_column :general_infos, :area_code, :string
  end
end
