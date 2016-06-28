class AddCodeToActionTypes < ActiveRecord::Migration
  def change
    add_column :action_types, :code, :string
  end
end
