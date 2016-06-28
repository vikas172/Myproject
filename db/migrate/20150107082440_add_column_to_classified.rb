class AddColumnToClassified < ActiveRecord::Migration
  def change
    add_column :classifieds, :license, :string
    add_column :classifieds, :license_info, :string
    add_column :classifieds, :user_id, :integer
  end
end
