require 'test_helper'

class VehiclesControllerTest < ActionController::TestCase
  setup do
    @vehicle = vehicles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vehicles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vehicle" do
    assert_difference('Vehicle.count') do
      post :create, vehicle: { body_subtype: @vehicle.body_subtype, body_type: @vehicle.body_type, color: @vehicle.color, driver: @vehicle.driver, group: @vehicle.group, license_plate: @vehicle.license_plate, make: @vehicle.make, model: @vehicle.model, msrp: @vehicle.msrp, ownership: @vehicle.ownership, registation: @vehicle.registation, status: @vehicle.status, trim: @vehicle.trim, type: @vehicle.type, vehicle_name: @vehicle.vehicle_name, vin_no: @vehicle.vin_no, year: @vehicle.year }
    end

    assert_redirected_to vehicle_path(assigns(:vehicle))
  end

  test "should show vehicle" do
    get :show, id: @vehicle
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vehicle
    assert_response :success
  end

  test "should update vehicle" do
    patch :update, id: @vehicle, vehicle: { body_subtype: @vehicle.body_subtype, body_type: @vehicle.body_type, color: @vehicle.color, driver: @vehicle.driver, group: @vehicle.group, license_plate: @vehicle.license_plate, make: @vehicle.make, model: @vehicle.model, msrp: @vehicle.msrp, ownership: @vehicle.ownership, registation: @vehicle.registation, status: @vehicle.status, trim: @vehicle.trim, type: @vehicle.type, vehicle_name: @vehicle.vehicle_name, vin_no: @vehicle.vin_no, year: @vehicle.year }
    assert_redirected_to vehicle_path(assigns(:vehicle))
  end

  test "should destroy vehicle" do
    assert_difference('Vehicle.count', -1) do
      delete :destroy, id: @vehicle
    end

    assert_redirected_to vehicles_path
  end
end
