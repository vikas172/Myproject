class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :permission_tasks
      t.boolean :permission_show_pricing
      t.string :permission_client_properties
      t.string :permission_quotes
      t.string :permission_invoices
      t.string :permission_jobs
      t.string :permission_note_attachment
      t.boolean :permission_reports

      t.timestamps
    end
  end
end
