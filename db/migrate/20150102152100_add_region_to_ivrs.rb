class AddRegionToIvrs < ActiveRecord::Migration
  def change
    add_column :ivrs, :region, :string , default: "USA"
  end
end
