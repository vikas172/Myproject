require 'test_helper'

class InventoriesControllerTest < ActionController::TestCase
  setup do
    @inventory = inventories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:inventories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create inventory" do
    assert_difference('Inventory.count') do
      post :create, inventory: { barcode: @inventory.barcode, barcode_type: @inventory.barcode_type, brand: @inventory.brand, currency: @inventory.currency, description: @inventory.description, notes: @inventory.notes, price: @inventory.price, price_sale: @inventory.price_sale, price_wholesale: @inventory.price_wholesale, product_name: @inventory.product_name, quantity: @inventory.quantity, shipping_unit: @inventory.shipping_unit, shipping_weight: @inventory.shipping_weight, sku: @inventory.sku }
    end

    assert_redirected_to inventory_path(assigns(:inventory))
  end

  test "should show inventory" do
    get :show, id: @inventory
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @inventory
    assert_response :success
  end

  test "should update inventory" do
    patch :update, id: @inventory, inventory: { barcode: @inventory.barcode, barcode_type: @inventory.barcode_type, brand: @inventory.brand, currency: @inventory.currency, description: @inventory.description, notes: @inventory.notes, price: @inventory.price, price_sale: @inventory.price_sale, price_wholesale: @inventory.price_wholesale, product_name: @inventory.product_name, quantity: @inventory.quantity, shipping_unit: @inventory.shipping_unit, shipping_weight: @inventory.shipping_weight, sku: @inventory.sku }
    assert_redirected_to inventory_path(assigns(:inventory))
  end

  test "should destroy inventory" do
    assert_difference('Inventory.count', -1) do
      delete :destroy, id: @inventory
    end

    assert_redirected_to inventories_path
  end
end
