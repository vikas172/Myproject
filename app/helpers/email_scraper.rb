class EmailScraper < ActiveRecord::Base

  validates_presence_of :name , :on => :create
  validates_presence_of :country , :on => :create
  validates :email, :presence => true
  validates_uniqueness_of  :email

end
