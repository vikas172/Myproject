class ChangeColumnSetDefaultToPermission < ActiveRecord::Migration
  def change
  	change_column :permissions, :permission_reports, :boolean, :default => false
  	change_column :permissions, :permission_show_pricing, :boolean, :default => false
  end
end
