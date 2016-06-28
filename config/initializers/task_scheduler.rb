require 'rubygems'
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.new
scheduler.every '1h' do
	@notify=NotificationsController.new
	@notify.team_member_notice
	@notify.client_notice
end
scheduler.in '1d' do
#scheduler.at '7:00 AM' do
@scheduler = ServiceRemindersController.new
@scheduler.service_notification
  #puts 'Hello... Rufus'
end
scheduler.every '1d' do
	@notify=NotificationsController.new
	@notify.invoice_mail
	
end