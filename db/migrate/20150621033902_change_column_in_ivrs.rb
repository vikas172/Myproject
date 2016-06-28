class ChangeColumnInIvrs < ActiveRecord::Migration
  def change
    rename_column :ivrs , :phone , :phone_number
    add_column :ivrs , :number_id , :integer
  end
end
