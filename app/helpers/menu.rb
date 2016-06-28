class Menu < ActiveRecord::Base

  belongs_to :key_action
  belongs_to :sub_menu , :class_name => "Ivr"
  before_create :set_is_sub_menu

  after_destroy :destroy_sub_menu

  def set_is_sub_menu
    Ivr.find(self.sub_menu_id).update(:is_sub_menu => true)
  end

  def destroy_sub_menu
    self.sub_menu.destroy
  end

end
