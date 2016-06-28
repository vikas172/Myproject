class RenameColumnIvrId < ActiveRecord::Migration
  def change
    rename_column :menus , :ivr_id , :key_id
  end
end
