class CreateCommunications < ActiveRecord::Migration
  def change
    create_table :communications do |t|
    	t.integer  :client_id
      t.integer  :user_id
    	t.date     :sent_date
    	t.string   :to
    	t.string   :cc
    	t.string   :subject
      t.text     :message
    	t.string   :status
    	t.string   :type
      t.string   :send_copy
    	t.time     :sent_time
    	t.date     :opened_date
      t.timestamps
    end
  end
end
