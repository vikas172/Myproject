class QuoteSerializer < ActiveModel::Serializer
  has_many :quote_works
  attributes :id,:tax, :discount, :discount_type, :require_deposit, :require_deposit_type, :client_message, :quote_order
end
