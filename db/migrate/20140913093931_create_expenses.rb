class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
    	t.date 		 :clean_date
			t.string 	 :name
			t.text 		 :note
			t.float 	 :cost
			t.integer  :reimbursable_to_id
			t.integer  :work_order_id
			t.integer  :user_id
      t.timestamps
    end
  end
end
