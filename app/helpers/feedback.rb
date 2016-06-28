class Feedback < ActiveRecord::Base
  belongs_to :user
  attr_accessor :return_url
  after_create :send_notification

  def send_notification
    UserMailer.delay.feedback_notification(self)
  end

end
