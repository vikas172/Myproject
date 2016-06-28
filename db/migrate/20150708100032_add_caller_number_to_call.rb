class AddCallerNumberToCall < ActiveRecord::Migration
  def change
    add_column :calls, :caller_number, :string
  end
end
