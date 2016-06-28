class AddApplicationIdToIvrs < ActiveRecord::Migration
  def change
    add_column :ivrs, :application_id, :string
  end
end
