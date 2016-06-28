Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  #config.assets.logger = false
  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  config.serve_static_assets = true
  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load
  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true


  # config.action_mailer.default_url_options = { :host => 'http://localhost:3000' }
  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = {
  # :address => "smtp.gmail.com",
  # :port => 587,
  # :domain => 'gmail',
  # :user_name => 'akshayyuvasoft129@gmail.com',
  # :password => 'yuvasoft',
  # :authentication => 'plain',
  # :enable_starttls_auto => true }

  
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
   :user_name => 'patel_kapil',
   :password => 'kapilyuvasoft133',
   :domain => 'localhost',
   :address => 'smtp.sendgrid.net',
   :port => 587,
   :authentication => :plain,
   :enable_starttls_auto => true
 }
  
# Open Weather APPID 
  WEATHER_APPID ="45c5cb2f83d12744849fd8797b8f19ac"

  require 'pusher'
  Pusher.logger = Rails.logger
  Pusher.app_id = 113456
  Pusher.key = 'd08eb71a0c0c3805381b'
  Pusher.secret = '4dd1155636043660f25c'
end