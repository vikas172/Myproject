class CreatePdfSettings < ActiveRecord::Migration
  def change
    create_table :pdf_settings do |t|
    	t.boolean 	 :show_company_name_on_pdfs, :default => true
    	t.boolean 	 :pdf_shows_phone, :default => true
    	t.boolean 	 :pdf_shows_email, :default => true
    	t.boolean 	 :pdf_shows_website, :default => true
    	t.boolean 	 :pdf_shows_client_phone, :default => true
    	t.boolean 	 :invoice_show_line_item_qty, :default => true
    	t.boolean 	 :invoice_show_line_item_unit_costs, :default => true
    	t.boolean 	 :invoice_show_line_item_total_costs, :default => true
    	t.boolean 	 :pdf_return_stub, :default => true
    	t.boolean 	 :invoice_show_late_stamp, :default => true
    	t.boolean 	 :invoice_show_account_balance, :default => true
    	t.text 	 		 :invoice_contract
    	t.boolean 	 :change_quote_to_estimate, :default => true
    	t.boolean 	 :quote_show_line_item_qty, :default => true
    	t.boolean 	 :quote_show_line_item_unit_costs, :default => true
    	t.boolean 	 :quote_show_line_item_total_costs, :default => true
    	t.boolean 	 :quote_show_totals, :default => true
    	t.boolean 	 :quote_client_signature, :default => true
    	t.text 	 		 :quote_contract
    	t.boolean 	 :require_work_order_signature, :default => true
    	t.text     	 :work_order_contract
    	t.integer    :user_id
      t.timestamps
    end
  end
end
