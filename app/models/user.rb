class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]
    has_many :properties  , :dependent => :destroy
    has_many :classifieds  , :dependent => :destroy
    has_many :documents  , :dependent => :destroy
    has_many :clients  , :dependent => :destroy
    has_many :email_notifications  , :dependent => :destroy
    has_many :events , :dependent => :destroy
    has_many :payment_invoices , :dependent => :destroy
    has_many :service_products , :dependent => :destroy
    has_many :basic_tasks , :dependent => :destroy
    has_many :team_members ,:dependent => :destroy
    has_many :invoices ,:dependent => :destroy
    has_many :timesheets, :dependent => :destroy
    has_many :expenses, :dependent => :destroy
    has_many :add_on_statuses, :dependent => :destroy
    has_many :jobs, :dependent => :destroy
    has_many :quotes  , :dependent => :destroy
    has_many :chemical_treatment_settings  , :dependent => :destroy
    has_many :chemical_treatment_mixtures  , :dependent => :destroy
    has_many :chamicals  , :dependent => :destroy
    has_many :custom_categories  , :dependent => :destroy
    has_one :general_info ,:dependent=>:destroy
    has_one :pdf_setting,:dependent=>:destroy
    has_one :permission,:dependent=>:destroy
    has_one :company,:dependent=>:destroy
    has_one :notification,:dependent=>:destroy
    has_one :custom_expense,:dependent=>:destroy
    has_one :spa_service ,:dependent => :destroy
    has_one :pool_service ,:dependent => :destroy
    has_one :phone_number ,:dependent => :destroy
    has_many :chemical_items ,:dependent => :destroy
    has_many :pool_tests ,:dependent => :destroy
    has_many :service_items ,:dependent => :destroy
    has_many :market_sources ,:dependent => :destroy
    has_many :service_plans ,:dependent => :destroy
    has_many :lead_templates ,:dependent => :destroy
    has_many :vendors ,:dependent => :destroy
    has_many :tracks ,:dependent => :destroy
    has_many :vehicles
    has_many :fuels 
    has_many :services
    has_many :service_reminders
    has_one :service_plan_label,:dependent => :destroy
    has_one :vendor_setting,:dependent => :destroy

    belongs_to :account
    has_many :reservations,:dependent=>:destroy
    has_many :ivrs,:dependent=>:destroy
    has_many :numbers,:dependent=>:destroy

    has_many :chats, :foreign_key => :sender_id
    #validates :full_name, :uniqueness => true

    # has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

      has_attached_file :avatar, :styles => {:thumb => "87x87"},
                    :default_url => "/assets/images/profile.png",
                    :url => "/assets/users/:id/:style/:basename.:extension",
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

    validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/


    devise :omniauthable, :omniauth_providers => [:stripe_connect]

    acts_as_messageable
    attr_accessor :login,:crop_x, :crop_y, :crop_x2, :crop_y2, :crop_w, :crop_h
   
    before_save do
     self.username = self.full_name
    end

    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
    end

  def name
    email
  end

  def mailboxer_email(object)
    email
  end
end
