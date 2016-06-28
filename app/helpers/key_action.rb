class KeyAction < ActiveRecord::Base
  belongs_to :key
  belongs_to :action_type

  has_many :menus, :dependent => :destroy
  has_many :sub_menus , :through => :menus
  accepts_nested_attributes_for :sub_menus
  after_create :check_duplicate

  # mount_uploader :play, AudioUploader


  def check_duplicate
  logger.debug "---------Removing the previous key action-----------"
    if self.key.key_actions.size > 1
      self.key.key_actions.first.destroy
    end
  end

  def dial=(dial)
    write_attribute(:dial, dial.gsub(/[^0-9\+]/, ''))
  end

end
