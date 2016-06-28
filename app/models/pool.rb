class Pool < ActiveRecord::Base
	belongs_to :property
	has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/photos/:style/missing.png"
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
end
