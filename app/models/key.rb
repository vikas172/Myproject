class Key < ActiveRecord::Base
  belongs_to :ivr
  belongs_to :action_type #, :dependent => :destroy
  has_many :key_actions, :dependent => :destroy


  # accepts_nested_attributes_for :key_actions
  attr_accessor :deleted_key_actions , :menu_id

  after_update :delete_key_actions, :if => :action_type_id_changed?

  #alias_attribute :menu_id , :ivr_id

  before_create :set_menu_id_and_order

  def set_menu_id_and_order
    self.menu_id = self.ivr_id

    logger.debug "=================setting display order=================="
    #Announcement,key1-9, key 0
    if self.digit != "10" and self.digit != "0"
      self.display_order =  self.digit.to_i + 1
    elsif self.digit == "10"
      self.display_order =  "1"
    elsif self.digit == "0"
      self.display_order =  11
    end
    logger.debug "=================digit=>" + self.digit + " disp=> " + self.display_order.to_s + "=================="

  end

  def delete_key_actions
    #delete previous key actions
    if self.deleted_key_actions.blank?
      if ["E" ,"RM" ,"NA"].include? self.action_type.code
        key_actions.destroy_all  if  !key_actions.blank?
      end
      key_actions.first.destroy  if  !key_actions.blank? and  key_actions.count > 1
      self.deleted_key_actions = true
    end
  end

end
