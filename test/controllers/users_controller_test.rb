# require 'test_helper'

# class UsersControllerTest < ActionDispatch::IntegrationTest
#   setup do
#     @user = users(:test_student)
#   end

#   test "should show dashboard" do
#     log_in_as @user
#     get dashboard_url @user
#     assert_response :success
#   end

#   test "should show user" do
#     log_in_as @user
#     get user_url @user
#     assert_response :success
#   end

#   test "should show edit" do
#     log_in_as @user
#     get edit_user_url @user
#     assert_response :success
#   end

#   # test "should get inadex" do
#   #   get users_url
#   #   assert_response :success
#   # end

#   # test "should get new" do
#   #   get new_user_url
#   #   assert_response :success
#   # end

#   # test "should create user" do
#   #   # assert_difference('User.count') do
#   #   post signup_url, params: { user: { email: "soemthing@email.com", name: "Name", password: "password", password_confirmation: "password", role: "student" } }
#   #   # end
#   #   # assert is_logged_in?
#   #   assert_redirected_to dashboard_url
#   # end

#   # test "should update user" do
#   #   patch user_url(@user), params: { user: { email: @user.email, name: @user.name, password_digest: @user.password_digest, remember_digest: @user.remember_digest, role: @user.role } }
#   #   assert_redirected_to user_url(@user)
#   # end

#   # test "should destroy user" do
#   #   assert_difference('User.count', -1) do
#   #     delete user_url(@user)
#   #   end
#   #
#   #   assert_redirected_to users_url
#   # end

# end
