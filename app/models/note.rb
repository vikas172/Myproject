class Note < ActiveRecord::Base
	has_many :attachments, dependent: :destroy
	belongs_to :quote
	belongs_to :job
	belongs_to :invoice
	belongs_to :client
	belongs_to :property
end
