class AddColumnToPermission < ActiveRecord::Migration
  def change
  	add_column :permissions, :to_dos, :string
  	add_column :permissions, :company_admin, :string
  end
end
