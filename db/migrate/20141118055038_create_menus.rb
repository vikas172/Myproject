class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.integer :ivr_id
      t.integer :sub_menu_id

      t.timestamps
    end
  end
end
