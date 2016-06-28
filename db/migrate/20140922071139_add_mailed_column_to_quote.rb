class AddMailedColumnToQuote < ActiveRecord::Migration
  def change
  	add_column :quotes, :is_mailed, :boolean, default: false
  end
end
