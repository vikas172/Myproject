class Property < ActiveRecord::Base
	belongs_to :client
	belongs_to :user
	has_many :jobs	, :dependent => :destroy
	has_many :quotes, :dependent => :destroy
	has_many :chamicals, :dependent => :destroy
	has_many :basic_tasks, :dependent => :destroy
	has_many :events, :dependent => :destroy
	has_many :pools, :dependent => :destroy
	has_one :pool_data, :dependent => :destroy
	has_one :spa_data, :dependent => :destroy
	has_many :notes, :dependent => :destroy
	has_many :activities, :dependent => :destroy
	has_many :sms_properties, :dependent => :destroy
	has_many :property_calls, :dependent => :destroy
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  acts_as_taggable_on :pool_tag
	serialize :custom_field
  # validates :street,:street2,:city,:state,:country,:zipcode, presence: true
  # validates_length_of :zipcode, maximum: 6
end
