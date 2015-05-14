require 'test_helper'

class B2bControllerTest < ActionController::TestCase
  test "should get documentation" do
    get :documentation
    assert_response :success
  end

  test "should get new_user" do
    get :new_user
    assert_response :success
  end

  test "should get get_token" do
    get :get_token
    assert_response :success
  end

  test "should get new_order" do
    get :new_order
    assert_response :success
  end

  test "should get order_accepted" do
    get :order_accepted
    assert_response :success
  end

  test "should get order_canceled" do
    get :order_canceled
    assert_response :success
  end

  test "should get order_rejected" do
    get :order_rejected
    assert_response :success
  end

  test "should get invoice_paid" do
    get :invoice_paid
    assert_response :success
  end

  test "should get invoice_rejected" do
    get :invoice_rejected
    assert_response :success
  end

end
