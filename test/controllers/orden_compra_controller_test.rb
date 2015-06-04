require 'test_helper'

class OrdenCompraControllerTest < ActionController::TestCase
  test "should get estado" do
    get :estado
    assert_response :success
  end

end
