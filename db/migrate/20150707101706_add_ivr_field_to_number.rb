class AddIvrFieldToNumber < ActiveRecord::Migration
  def change
    add_column :numbers, :ivr_id, :integer
  end
end
