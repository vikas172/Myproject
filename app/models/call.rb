class Call < ActiveRecord::Base
  belongs_to :ivr
  has_many :transactions , :dependent => :destroy
end
