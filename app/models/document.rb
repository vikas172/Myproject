class Document < ActiveRecord::Base
	belongs_to :user
	# has_attached_file :file, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  has_attached_file :file, :styles => {:medium => "300x300>", :thumb => "900x900>"  },
              :default_url => "/assets/files/file.png",
              :url => "/documents/:id/:style/:basename.:extension",
              :storage => :s3,
              # :bucket => 'copperservice1',
              # # :s3_credentials => {
              # # :access_key_id => 'AKIAJABVFMLWVFM6RCZQ',
              # # :secret_access_key => '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'
              # # } 

              # :s3_credentials => {
              # :access_key_id => 'AKIAJYLXXQWZS4IWEUOQ',
              # :secret_access_key => '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'
              # } 
              :bucket => 'poolpath',
              :s3_credentials => {
              :access_key_id => 'AKIAJNWRCORXNZLE7WIA',
              :secret_access_key => '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'
              } 
  
  validates_attachment_content_type :file, :content_type => ['image/jpg','image/jpeg','image/pjpeg','image/png','image/x-png','image/gif','application/pdf','application/msword','applicationvnd.ms-word','applicaiton/vnd.openxmlformats-officedocument.wordprocessingm1.document','application/msexcel','application/vnd.ms-excel','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet','application/mspowerpoint','application/vnd.ms-powerpoint','application/vnd.openxmlformats-officedocument.presentationml.presentation']
  STORAGE= [10000000000,25000000000,100000000000]
end
