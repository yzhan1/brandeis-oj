require 'test_helper'
require 'sessions_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:test_student)
  end

  test "should get new" do
    get login_url
    assert_response :success
  end

  test "should log in" do
    log_in_as @user
    assert_equal is_logged_in?, true
  end
end
