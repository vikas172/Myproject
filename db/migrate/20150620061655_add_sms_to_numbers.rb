class AddSmsToNumbers < ActiveRecord::Migration
  def change
    add_column :numbers, :sms, :string
  end
end
