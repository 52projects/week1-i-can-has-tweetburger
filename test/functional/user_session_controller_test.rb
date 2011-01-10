require 'test_helper'

class UserSessionControllerTest < ActionController::TestCase
  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get callback" do
    get :callback
    assert_response :success
  end

end
