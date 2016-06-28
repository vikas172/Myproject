class AddComepleteFieldToServiceItem < ActiveRecord::Migration
  def change
    add_column :service_items, :status, :string
  end
end
