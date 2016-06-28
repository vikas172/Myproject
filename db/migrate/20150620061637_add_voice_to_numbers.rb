class AddVoiceToNumbers < ActiveRecord::Migration
  def change
    add_column :numbers, :voice, :string
  end
end
