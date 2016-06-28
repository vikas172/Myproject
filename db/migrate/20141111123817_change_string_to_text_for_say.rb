class ChangeStringToTextForSay < ActiveRecord::Migration
  def change
    change_column :key_actions , :say , :text
    change_column :key_actions , :record , :text
    change_column :key_actions , :sms , :text

  end
end
