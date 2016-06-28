class AddFieldToNote < ActiveRecord::Migration
  def change
    add_column :notes, :job_id, :integer
    add_column :notes, :invoice_id, :integer
  end
end
