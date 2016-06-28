class AddFieldArchiveToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :archive, :boolean, default: false
    add_column :quotes, :sent, :boolean, default: false
  end
end
