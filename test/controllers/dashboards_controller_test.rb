require 'test_helper'

class DashboardsControllerTest < ActionController::TestCase
  test "should get ventas" do
    get :ventas
    assert_response :success
  end

end
