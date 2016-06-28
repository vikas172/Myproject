require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  setup do
    @invoice = invoices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invoices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invoice" do
    assert_difference('Invoice.count') do
      post :create, invoice: { additional_note: @invoice.additional_note, client_message: @invoice.client_message, deposite_amount: @invoice.deposite_amount, discount_amount: @invoice.discount_amount, discount_type: @invoice.discount_type, entry_date: @invoice.entry_date, issued_date: @invoice.issued_date, payment: @invoice.payment, payment_method: @invoice.payment_method, payment_method_type: @invoice.payment_method_type, subject: @invoice.subject, tax: @invoice.tax }
    end

    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should show invoice" do
    get :show, id: @invoice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @invoice
    assert_response :success
  end

  test "should update invoice" do
    patch :update, id: @invoice, invoice: { additional_note: @invoice.additional_note, client_message: @invoice.client_message, deposite_amount: @invoice.deposite_amount, discount_amount: @invoice.discount_amount, discount_type: @invoice.discount_type, entry_date: @invoice.entry_date, issued_date: @invoice.issued_date, payment: @invoice.payment, payment_method: @invoice.payment_method, payment_method_type: @invoice.payment_method_type, subject: @invoice.subject, tax: @invoice.tax }
    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should destroy invoice" do
    assert_difference('Invoice.count', -1) do
      delete :destroy, id: @invoice
    end

    assert_redirected_to invoices_path
  end
end
