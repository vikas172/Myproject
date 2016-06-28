class AddTypeFileToLeadTemplate < ActiveRecord::Migration
  def change
    add_column :lead_templates, :pool_activity_type, :string
  end
end
