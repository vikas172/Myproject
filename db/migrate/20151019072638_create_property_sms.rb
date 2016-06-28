class CreatePropertySms < ActiveRecord::Migration
  def change
    create_table :property_sms do |t|
      t.string :from
      t.string :to
      t.string :other_number
      t.string :body
      t.integer :property_id
      t.integer :user_id
      t.string :sms_twilio_id

      t.timestamps
    end
  end
end
