class Support < ActiveRecord::Base
	  has_attached_file :file, :styles => {:thumb => "87x87"},
              :default_url => "/assets/images/image.png",
              :url => "/assets/supports/:id/:style/:basename.:extension",
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



 validates_attachment_content_type :file, :content_type => ['application/pdf', 'application/msword', 'text/plain','image/png', 'image/gif', 'image/jpeg']
 
end
