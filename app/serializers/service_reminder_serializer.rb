class ServiceReminderSerializer < ActiveModel::Serializer
  attributes :id, :vehicle_name, :service_task, :meter_interval, :time_interval, :time_duration, :meter_threshold, :time_threshold, :threshold_duration, :email_notification, :subscribed_user
end
