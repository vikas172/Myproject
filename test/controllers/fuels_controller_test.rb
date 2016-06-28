require 'test_helper'

class FuelsControllerTest < ActionController::TestCase
  setup do
    @fuel = fuels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fuels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fuel" do
    assert_difference('Fuel.count') do
      post :create, fuel: { comment: @fuel.comment, date: @fuel.date, fuel_type: @fuel.fuel_type, mark_as_expense: @fuel.mark_as_expense, mark_as_void: @fuel.mark_as_void, odometer: @fuel.odometer, partial_fuel_up: @fuel.partial_fuel_up, price: @fuel.price, reference: @fuel.reference, vandor_name: @fuel.vandor_name, vehicle_id: @fuel.vehicle_id }
    end

    assert_redirected_to fuel_path(assigns(:fuel))
  end

  test "should show fuel" do
    get :show, id: @fuel
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fuel
    assert_response :success
  end

  test "should update fuel" do
    patch :update, id: @fuel, fuel: { comment: @fuel.comment, date: @fuel.date, fuel_type: @fuel.fuel_type, mark_as_expense: @fuel.mark_as_expense, mark_as_void: @fuel.mark_as_void, odometer: @fuel.odometer, partial_fuel_up: @fuel.partial_fuel_up, price: @fuel.price, reference: @fuel.reference, vandor_name: @fuel.vandor_name, vehicle_id: @fuel.vehicle_id }
    assert_redirected_to fuel_path(assigns(:fuel))
  end

  test "should destroy fuel" do
    assert_difference('Fuel.count', -1) do
      delete :destroy, id: @fuel
    end

    assert_redirected_to fuels_path
  end
end
