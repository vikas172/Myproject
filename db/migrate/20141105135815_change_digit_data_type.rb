class ChangeDigitDataType < ActiveRecord::Migration
  def change
    change_column :keys , :digit , :string
  end
end
