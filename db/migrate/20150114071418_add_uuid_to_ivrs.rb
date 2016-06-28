class AddUuidToIvrs < ActiveRecord::Migration
  def change
    add_column :ivrs, :uuid, :string
  end
end
