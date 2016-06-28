class Classified < ActiveRecord::Base
  belongs_to :user
	# has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  has_attached_file :image, :styles => {:thumb => "87x87"},
              :default_url => "/assets/images/image.png",
              :url => "/assets/classifieds/:id/:style/:basename.:extension",
              :storage => :s3,
              :bucket => 'poolpath',
              # :bucket => 'copperservice1',
              # :s3_credentials => {
              # :access_key_id => 'AKIAJABVFMLWVFM6RCZQ',
              # :secret_access_key => '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'
              # } 

              # :s3_credentials => {
              # :access_key_id => 'AKIAJYLXXQWZS4IWEUOQ',
              # :secret_access_key => '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'
              # } 
              :s3_credentials => {
              :access_key_id => 'AKIAJNWRCORXNZLE7WIA',
              :secret_access_key => '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'
              } 



  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
