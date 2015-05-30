require 'test_helper'

class InternacionalControllerTest < ActionController::TestCase
  test "should get ftp" do
    get :ftp
    assert_response :success
  end

end
