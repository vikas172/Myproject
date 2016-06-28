class AddIsTemplateToIvrs < ActiveRecord::Migration
  def change
    add_column :ivrs, :is_template, :boolean
  end
end
