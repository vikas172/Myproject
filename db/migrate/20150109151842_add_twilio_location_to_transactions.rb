class AddTwilioLocationToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :twilio_location, :string
  end
end
