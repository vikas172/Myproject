require 'rexml/document'
require 'builder'
require 'open-uri'
class Ivr < ActiveRecord::Base
  has_many :keys, :dependent => :destroy
  has_many :calls
  has_many :reservations
  has_one :number
  belongs_to :user
  accepts_nested_attributes_for :keys
  # before_create :set_uuid


  def phone
    if number
      number.phone_number
    else
      nil
    end
  end

  #enable calls for ivr
  def recharge(pack)
    logger.debug "Recharging IVR =>" + self.id.to_s
    if "silver" == pack
      self.call_balance = self.call_balance + 100
    elsif "gold" == pack
      self.call_balance = self.call_balance + 500
    elsif "platinum" == pack
      self.call_balance = self.call_balance + 2000
    end
    #Activating the attendant
    self.state = "active"
    self.save

  end

  # def set_uuid
  #   self.uuid = SecureRandom.uuid
  # end

  def download_file(url, t)
    File.open("#{$recordings_destination}/#{t.id}", "wb") do |saved_file|
      # the following "open" is provided by open-uri
      open(url, "rb") do |read_file|
        saved_file.write(read_file.read)
      end
    end

  end

  #create a blank ivr with default options
  def self.create_blank_ivr(name, phone, free = nil)
    @ivr = Ivr.new(:name => name, :phone_number => phone, :state => "pending_activation", :free => free, :call_balance => 0)

    #For announcement
    key = @ivr.keys.build(:digit => "10", :action_type_id => ActionType.find_by_code("PT").id)
    key.key_actions.build(:say => "")

    #For other keys
    10.times do |i|
      key = @ivr.keys.build(:digit => i.to_s, :action_type_id => ActionType.find_by_code("NA").id)
      key.key_actions.build
    end

    @ivr.save
    @ivr
  end

  #for sales
  def self.create_standalone_ivr(name)
    @ivr = Ivr.new(:name => name, :state => "active", :free => true, :call_balance => 0)

    #For announcement
    key = @ivr.keys.build(:digit => "10", :action_type_id => ActionType.find_by_code("PT").id)
    key.key_actions.build(:say => "")

    #For other keys
    10.times do |i|
      key = @ivr.keys.build(:digit => i.to_s, :action_type_id => ActionType.find_by_code("NA").id)
      key.key_actions.build
    end

    @ivr.save
    @ivr
  end


  #recharge soon message
  def recharge_soon_ivr
    xml_string = Gyoku.xml({"Response" =>
                                {
                                    "Say" => "Hello , Call limit has expired for this IVR . If you are the owner of this IVR please recharge with one of our call packs at autoattend.com . Thank you ! ",
                                }})
    doc = Nokogiri::XML(xml_string)
    logger.debug "====================TWIML===================="
    logger.debug doc.human

    logger.debug "====================END OF TWIML===================="
    doc
  end

  #handle key press events
  def generate_twiml_keypress(digits, caller = nil)
    json = {}

    self.keys.where(:digit => digits).order(:digit).each do |key|
      action = key.key_actions.first
      if key.action_type.code == "PT"
        json.merge!({"Say" => action.say})
      elsif key.action_type.code == "SMS"
        json.merge!({"Sms" => {:@statusCallback => "#{sms_url}", :content! => action.sms}})
      elsif key.action_type.code == "PTRM" and self.is_sub_menu.blank?
        json.merge!({"Say" => action.say, "Redirect" => {
            :@method => "GET",
            :content! => "#{twiml_url}/repeat_menu"
        }})
        #  for submenu
      elsif key.action_type.code == "PTRM"
        json.merge!({"Say" => action.say, "Redirect" => {
            :@method => "GET",
            :content! => "#{twiml_url}/repeat_menu/#{self.uuid}"
        }})
      elsif key.action_type.code == "PTTN"
        json.merge!({"Say" => action.say, "Dial" => {:@callerId => self.phone, :content! => action.dial}})
      elsif key.action_type.code == "TN"
        json.merge!({"Dial" => {:@callerId => self.phone, :content! => action.dial}})
      elsif key.action_type.code == "PM"
        json.merge!({"Play" => action.play.url})
      elsif key.action_type.code == "PMRM" and self.is_sub_menu.blank?
        json.merge!({"Play" => action.play.url, "Redirect" => {
            :@method => "GET",
            :content! => "#{twiml_url}/repeat_menu"
        }})
      elsif key.action_type.code == "PMRM"
        json.merge!({"Play" => action.play.url, "Redirect" => {
            :@method => "GET",
            :content! => "#{twiml_url}/repeat_menu/#{self.uuid}"
        }})
      elsif key.action_type.code == "TSB"
        return action.sub_menus.first.generate_twiml_menu if !action.sub_menus.blank?
      elsif key.action_type.code == "PTRC"
        json.merge!({"Say" => action.say.blank? ? $record_text : action.say, "Record" => [{
                                                                                              :@method => "GET",
                                                                                              :@action => handle_recording_url,
                                                                                              :@finishOnKey => "*"
                                                                                          }]})
      elsif key.action_type.code == "RM"
        #repeat main menu or submenu
        if self.is_sub_menu.blank?
          json.merge!({"Redirect" => {
              :@method => "GET",
              :content! => "#{twiml_url}/repeat_menu"
          }
                      })
        else
          json.merge!({"Redirect" => {
              :@method => "GET",
              :content! => "#{twiml_url}/repeat_menu/#{self.uuid}"
          }
                      })
        end
      elsif key.action_type.code == "GTPM"
        json.merge!({"Redirect" => {
            :@method => "GET",
            :content! => "#{twiml_url}/repeat_menu/#{Menu.find_by_sub_menu_id(self.id).key_action.key.ivr.id}"
        }
                    });
      end
    end

    xml_string = Gyoku.xml({"Response" =>
                                {
                                    :content! => json,
                                }})
    doc = Nokogiri::XML(xml_string)
    logger.debug "====================TWIML===================="
    logger.debug doc.human

    logger.debug "====================END OF TWIML===================="
    doc
  end

  def twiml_url
    if Rails.env == "development"
      "http://58a6b0.ngrok.com/ivrs/42827ca66fd341bdbc180b4f6e7f1b74/twiml"
    else
      "http://45.55.157.4/ivrs/#{self.uuid}/twiml"
      # "http://45.55.73.82:3000/ivrs/#{self.uuid}/twiml"
    end
  end


  def sms_url
    if Rails.env == "development"
      "http://58a6b0.ngrok.com/#{self.uuid}/sms_callback"
    else
      # "http://45.55.73.82:3000/ivrs/#{self.uuid}/sms_callback"
      "http://45.55.157.4/ivrs/#{self.uuid}/sms_callback"
    end
  end

  def handle_recording_url
    if Rails.env == "development"
      "http:///ivrs/#{self.uuid}/handle_recording"
    else
      # "http://45.55.73.82:3000/ivrs/#{self.uuid}/handle_recording"
      "http://45.55.157.4/ivrs/#{self.uuid}/handle_recording"
    end
  end

  #read out menus and submenus
  def generate_twiml_menu

    gather_hash = {}
    announcement = nil

    self.keys.each do |key|
      action = key.key_actions.first
      #announcement
      if key.digit == "10"
        if key.action_type.code == "PT"
          announcement = {"Say" => action.say}
        elsif key.action_type.code == "PM" and action.play
          announcement = {"Play" => action.play.url}
        end
        next
      end

      if ["PT", "TN", "PTTN", "PM", "PTRC", "RM", "TSB"].include? key.action_type.code
        gather_hash = {
            :@numDigits => "1",
            :@method => "GET",
            :@action => self.is_sub_menu ? "#{twiml_url}/#{self.uuid}" : twiml_url,
            :content! => announcement

        }
      end
    end

    #if announcement alone present
    if gather_hash.blank? and !announcement.blank?
      gather_hash = {
          :@numDigits => "1",
          :@method => "GET",
          :@action => self.is_sub_menu ? "#{twiml_url}/#{self.uuid}" : twiml_url,
          :content! => announcement

      }
    end

    #Add pause for 3 seconds before playing text
    json = {
        #"Pause" => { :@length => "3"} ,
        "Gather" => gather_hash,
        "Say" => "I am sorry. I did not receive any input",
        "Redirect" => {
            :@method => "GET",
            :content! => "#{twiml_url}/repeat_menu"
        }
    }

    xml_string = Gyoku.xml("Response" => {
        :content! => json
    })
    doc = Nokogiri::XML(xml_string)
    logger.debug "====================TWIML===================="
    logger.debug doc.human
    logger.debug "====================END OF TWIML===================="
    doc
  end

  #reset the ivr as if newly created.
  def reset_ivr
    na = ActionType.find_by_code("NA").id
    pt = ActionType.find_by_code("PT").id
    self.keys.each do |key|
      #Announcement
      if key.digit == "10"
        key.update :action_type_id => pt
        key.key_actions.first.update :say => "" if key.key_actions.first
        next
      end

      key.key_actions.each do |key_action|
        key_action.destroy
        key.key_actions << KeyAction.new
      end
      key.update :action_type_id => na
    end
  end

  def release_ivr
    reset_ivr
    self.update :current_user => nil
  end

  #return new ivr
  def copy_ivr
    new_ivr = self.dup
    new_ivr.save
    self.keys.each do |key|
      key_dup = key.dup
      key_dup.ivr_id = new_ivr.id
      key_dup.save
      key.key_actions.each do |key_action|
        key_action_dup = key_action.dup
        #key_action_dup.key_id =  key_dup.id
        key_action_dup.save
        key_dup.key_actions << key_action_dup

        sub_menu_dup = nil
        key_action.sub_menus.each do |sub_menu|
          logger.debug "=============================sub menu======================"
          sub_menu_dup = sub_menu.copy_ivr
          sub_menu_dup.save
        end

        key_action.menus.each do |menu|
          logger.debug "=============================menu======================"
          menu_dup = menu.dup
          menu_dup.sub_menu_id = sub_menu_dup.id
          menu_dup.key_action_id = key_action_dup.id
          menu_dup.save
        end

      end
    end

    new_ivr
  end

  def use_recipe_ivr(template_id)
    #1. Destroy all keys , key actions, sub menus of current IVR
    #2. Dup all keys , key actions , sub menus of template IVR
    #3. Save the duplicated items into current IVR

    template_ivr = Ivr.find_by_id(template_id)

    if template_ivr

      self.keys.each do |key|
        key.key_actions.each do |key_action|
          #key_action.menus.each do |menu|
          #  menu.destroy
          #end
          key_action.destroy
        end
        key.destroy
      end

      template_ivr.keys.each do |key|
        key_dup = key.dup
        key_dup.ivr_id = self.id
        key_dup.save
        key.key_actions.each do |key_action|
          key_action_dup = key_action.dup
          key_action_dup.key_id = key_dup.id
          key_action_dup.save
          #key_dup.key_actions << key_action_dup

          sub_menu_dup = nil
          key_action.sub_menus.each do |sub_menu|
            logger.debug "=============================sub menu======================"
            sub_menu_dup = sub_menu.copy_ivr
            sub_menu_dup.save
          end

          key_action.menus.each do |menu|
            logger.debug "=============================menu======================"
            menu_dup = menu.dup
            menu_dup.sub_menu_id = sub_menu_dup.id
            menu_dup.key_action_id = key_action_dup.id
            menu_dup.save
          end

        end
      end
    end
  end
end
