class AddFieldPostcardIdToPostcard < ActiveRecord::Migration
  def change
    add_column :postcards, :post_card_id, :string
  end
end
