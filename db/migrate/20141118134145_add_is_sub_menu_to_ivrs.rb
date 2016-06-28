class AddIsSubMenuToIvrs < ActiveRecord::Migration
  def change
    add_column :ivrs, :is_sub_menu, :boolean
  end
end
