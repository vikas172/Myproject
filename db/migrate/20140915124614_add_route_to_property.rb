class AddRouteToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :add_route, :boolean, default: false
  end
end
