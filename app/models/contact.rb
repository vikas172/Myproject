# Simple model to handle validation
class Contact
  include ActiveModel::Validations
  attr_accessor :phone
  validates_presence_of :phone
end