require 'test_helper'

class ClassifiedsControllerTest < ActionController::TestCase
  setup do
    @classified = classifieds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:classifieds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create classified" do
    assert_difference('Classified.count') do
      post :create, classified: { city: @classified.city, contact_name: @classified.contact_name, contact_ok: @classified.contact_ok, contact_phone: @classified.contact_phone, contact_text: @classified.contact_text, phone_number: @classified.phone_number, postal_code: @classified.postal_code, posting_body: @classified.posting_body, posting_title: @classified.posting_title, privacy: @classified.privacy, show_on_map: @classified.show_on_map, specific_location: @classified.specific_location, state: @classified.state, street: @classified.street, zipcode: @classified.zipcode }
    end

    assert_redirected_to classified_path(assigns(:classified))
  end

  test "should show classified" do
    get :show, id: @classified
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @classified
    assert_response :success
  end

  test "should update classified" do
    patch :update, id: @classified, classified: { city: @classified.city, contact_name: @classified.contact_name, contact_ok: @classified.contact_ok, contact_phone: @classified.contact_phone, contact_text: @classified.contact_text, phone_number: @classified.phone_number, postal_code: @classified.postal_code, posting_body: @classified.posting_body, posting_title: @classified.posting_title, privacy: @classified.privacy, show_on_map: @classified.show_on_map, specific_location: @classified.specific_location, state: @classified.state, street: @classified.street, zipcode: @classified.zipcode }
    assert_redirected_to classified_path(assigns(:classified))
  end

  test "should destroy classified" do
    assert_difference('Classified.count', -1) do
      delete :destroy, id: @classified
    end

    assert_redirected_to classifieds_path
  end
end
