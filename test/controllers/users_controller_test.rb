require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:test_student)
    @user_two = users(:another_student)
    @test_teacher = users(:test_teacher)
    @course = courses(:course_one)
    @course_two = courses(:course_two)
    @test_teacher.enroll_course('11a')
  end

  test "should show dashboard" do
    log_in_as @user
    get dashboard_url @user
    assert_response :success
  end

  test "should show user" do
    log_in_as @user
    get user_url @user
    assert_response :success
  end

  test "should not visit other's user page" do
    log_in_as @user
    get user_url @user_two
    assert_redirected_to error_url
  end

  test "should show edit" do
    log_in_as @user
    get edit_user_url @user
    assert_response :success
  end

  test "should not show edit for other users" do
    log_in_as @user
    get edit_user_url @user_two
    assert_redirected_to error_url
  end

  test "should update user" do
    log_in_as @user
    patch user_url(@user), params: { 
      user: { 
        phone: 1234567890
      } 
    }
    assert_redirected_to user_url(@user)
  end

  test "should not update other users" do
    log_in_as @user
    patch user_url(@user_two), params: { 
      user: { 
        phone: 1234567890
      } 
    }
    assert_redirected_to error_url
  end

  test "should create new announcement" do
    log_in_as @test_teacher
    assert_difference('Announcement.count') do
      post announce_url, params: {
        announcement: {
          course: @course.id,
          announcement_body: 'Hello',
          title: 'Test'
        }
      }
    end
    assert_redirected_to dashboard_url
  end

  test "should not create new announcement if user is not teaching the course" do
    log_in_as @test_teacher
    assert_difference('Announcement.count', 0) do
      post announce_url, params: {
        announcement: {
          course: @course_two.id,
          announcement_body: 'Hello',
          title: 'Test'
        }
      }
    end
    assert_redirected_to error_url
  end
end
