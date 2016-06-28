class Transaction < ActiveRecord::Base
  belongs_to :call
  belongs_to :key_action

  attr_accessor :start_date , :end_date
end
