require 'test_helper'

class ServiceRemindersControllerTest < ActionController::TestCase
  setup do
    @service_reminder = service_reminders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:service_reminders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create service_reminder" do
    assert_difference('ServiceReminder.count') do
      post :create, service_reminder: { email_notification: @service_reminder.email_notification, meter_interval: @service_reminder.meter_interval, meter_threshold: @service_reminder.meter_threshold, service_task: @service_reminder.service_task, subscribed_user: @service_reminder.subscribed_user, threshold_duration: @service_reminder.threshold_duration, time_duration: @service_reminder.time_duration, time_interval: @service_reminder.time_interval, time_threshold: @service_reminder.time_threshold, vehicle_name: @service_reminder.vehicle_name }
    end

    assert_redirected_to service_reminder_path(assigns(:service_reminder))
  end

  test "should show service_reminder" do
    get :show, id: @service_reminder
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @service_reminder
    assert_response :success
  end

  test "should update service_reminder" do
    patch :update, id: @service_reminder, service_reminder: { email_notification: @service_reminder.email_notification, meter_interval: @service_reminder.meter_interval, meter_threshold: @service_reminder.meter_threshold, service_task: @service_reminder.service_task, subscribed_user: @service_reminder.subscribed_user, threshold_duration: @service_reminder.threshold_duration, time_duration: @service_reminder.time_duration, time_interval: @service_reminder.time_interval, time_threshold: @service_reminder.time_threshold, vehicle_name: @service_reminder.vehicle_name }
    assert_redirected_to service_reminder_path(assigns(:service_reminder))
  end

  test "should destroy service_reminder" do
    assert_difference('ServiceReminder.count', -1) do
      delete :destroy, id: @service_reminder
    end

    assert_redirected_to service_reminders_path
  end
end
