class RenameColumnKeyId < ActiveRecord::Migration
  def change
    rename_column :menus ,  :key_id , :key_action_id
  end
end
