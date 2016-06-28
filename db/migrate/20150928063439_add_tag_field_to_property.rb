class AddTagFieldToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :pool_tag, :text
    add_column :properties, :pool_source, :string
    add_column :properties, :converted_date, :string
    add_column :properties, :pool_subject, :string
    add_column :properties, :pool_comment, :text
  end
end
