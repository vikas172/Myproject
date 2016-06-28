class EmailNotification < ActiveRecord::Base
	belongs_to :user
  validates :body, :presence => true

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

 has_attached_file :image, :styles => {:thumb => "87x87"},
              :default_url => "/assets/images/file.png",
              :url => "/assets/email_notification/:id/:style/:basename.:extension",
              :storage => :s3,
              # :bucket => 'copperservice1',
              # :s3_credentials => {
              # :access_key_id => 'AKIAJYLXXQWZS4IWEUOQ',
              # :secret_access_key => '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'
              # } 
              :bucket => 'poolpath',
              # :s3_credentials => {
              # :access_key_id => 'AKIAJABVFMLWVFM6RCZQ',
              # :secret_access_key => '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'
              # } 

              :s3_credentials => {
              :access_key_id => 'AKIAJNWRCORXNZLE7WIA',
              :secret_access_key => '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'
              } 

end
