class AddFieldLableToPart < ActiveRecord::Migration
  def change
    add_column :parts, :l_item, :string
    add_column :parts, :l_description, :string
    add_column :parts, :l_p_price, :string
    add_column :parts, :l_p_code, :string
    add_column :parts, :l_s_price, :string
    add_column :parts, :l_s_code, :string
    add_column :parts, :l_profit, :string
    add_column :parts, :l_margin, :string
  end
end
