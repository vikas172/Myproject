class Attachment < ActiveRecord::Base
	belongs_to :note
	# has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "900x900>" }, :default_url => "/images/:style/missing.png"
  has_attached_file :image, :styles => {:medium => "300x300>", :thumb => "900x900>" },
              :default_url => "/assets/images/image.png",
              :url => "/assets/attachments/:id/:style/:basename.:extension",
              :storage => :s3,
              :bucket => 'poolpath',
              # :s3_credentials => {
              # :access_key_id => 'AKIAJABVFMLWVFM6RCZQ',
              # :secret_access_key => '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'
              # } 

              :s3_credentials => {
              :access_key_id => 'AKIAJNWRCORXNZLE7WIA',
              :secret_access_key => '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'
              } 
 #validates_attachment_content_type :image, :content_type => ['application/pdf', 'application/msword', 'text/plain','image/png', 'image/gif', 'image/jpeg']
 validates_attachment_content_type :image, :content_type => ['application/octet-stream','application/pdf', 'application/msword', 'text/plain','image/png', 'image/gif', 'image/jpeg']
end
