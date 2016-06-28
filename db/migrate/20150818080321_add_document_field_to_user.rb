class AddDocumentFieldToUser < ActiveRecord::Migration
  def change
    add_column :users, :hr_document, :boolean, :default => false
    add_column :users, :company_document, :boolean, :default => false
    add_column :users, :contract_document, :boolean, :default => false
  end
end
