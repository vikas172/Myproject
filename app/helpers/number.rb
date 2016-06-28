class Number < ActiveRecord::Base
  belongs_to :user
  belongs_to :ivr
  attr_accessor :prefix
  #validates_presence_of :account_sid , :auth_token, :phone_sid , :phone_number , :voice
  #validates_uniqueness_of :phone_sid , :phone_number

  def configure_in_twilio

    logger.debug "=====> Configuring in twilio"

    client = Twilio::REST::Client.new(self.account_sid , self.auth_token)
    numbers = client.account.incoming_phone_numbers
    number = client.account.incoming_phone_numbers.get(self.phone_sid)

    #sms
    if !self.sms.blank?
      number.update(:sms_url => self.sms ,:voice_method => "GET")
    end

    #voice
    # if !self.voice.blank?
    #    number.update(:voice_url => self.voice ,:voice_method => "GET")
    # end

  end
end
