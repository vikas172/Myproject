class AddTemplateCodeToIvrs < ActiveRecord::Migration
  def change
    add_column :ivrs, :template_code, :string
  end
end
