class QuoteWorkSerializer < ActiveModel::Serializer
  attributes :id,:name,:description,:quantity,:unit_cost,:total,:quote_id
end
