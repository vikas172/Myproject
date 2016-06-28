class CreateAddOnStatuses < ActiveRecord::Migration
  def change
    create_table :add_on_statuses do |t|
    	t.boolean :status ,:default=>false
    	t.boolean :paid ,:default=>false
    	t.float :charge ,:default=>0
    	t.integer :user_id
      t.string :add_on
    	t.date :active_date
      t.timestamps
    end
  end
end


