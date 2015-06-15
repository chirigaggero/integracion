require 'test_helper'

class EcommerceControllerTest < ActionController::TestCase
  test "should get products" do
    get :products
    assert_response :success
  end

  test "should get shoppingcart" do
    get :shoppingcart
    assert_response :success
  end

  test "should get checkout" do
    get :checkout
    assert_response :success
  end

end
