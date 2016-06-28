require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  setup do
    @client = clients(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clients)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create client" do
    assert_difference('Client.count') do
      post :create, client: { city: @client.city, company_name: @client.company_name, country: @client.country, email: @client.email, email_initial: @client.email_initial, first_name: @client.first_name, initial: @client.initial, last_name: @client.last_name, phone_initial: @client.phone_initial, phone_number: @client.phone_number, primary_company: @client.primary_company, state: @client.state, street1: @client.street1, street2: @client.street2, zip_code: @client.zip_code }
    end

    assert_redirected_to client_path(assigns(:client))
  end

  test "should show client" do
    get :show, id: @client
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @client
    assert_response :success
  end

  test "should update client" do
    patch :update, id: @client, client: { city: @client.city, company_name: @client.company_name, country: @client.country, email: @client.email, email_initial: @client.email_initial, first_name: @client.first_name, initial: @client.initial, last_name: @client.last_name, phone_initial: @client.phone_initial, phone_number: @client.phone_number, primary_company: @client.primary_company, state: @client.state, street1: @client.street1, street2: @client.street2, zip_code: @client.zip_code }
    assert_redirected_to client_path(assigns(:client))
  end

  test "should destroy client" do
    assert_difference('Client.count', -1) do
      delete :destroy, id: @client
    end

    assert_redirected_to clients_path
  end
end
