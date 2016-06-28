class AddCurrencyToGeneralInfo < ActiveRecord::Migration
  def change
    add_column :general_infos, :currency, :string
  end
end
