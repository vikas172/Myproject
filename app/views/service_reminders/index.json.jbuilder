json.array!(@service_reminders) do |service_reminder|
  json.extract! service_reminder, :id, :vehicle_name, :service_task, :meter_interval, :time_interval, :time_duration, :meter_threshold, :time_threshold, :threshold_duration, :email_notification, :subscribed_user
  json.url service_reminder_url(service_reminder, format: :json)
end
