class AddClientTagFieldToClient < ActiveRecord::Migration
  def change
    add_column :clients, :client_tag, :text
  end
end
