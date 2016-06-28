class AddSourceFieldToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :source, :string
  end
end
