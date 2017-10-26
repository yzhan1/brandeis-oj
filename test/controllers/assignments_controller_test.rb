require 'test_helper'

class AssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @test_teacher = users(:test_teacher)
    @test_student = users(:test_student)
    @test_teacher.enroll_course('11a')
    @test_student.enroll_course('11a')
    @assignment = assignments(:one)
    @course = courses(:one)
    @assignment.course = @course
  end

  test "should get new" do
    log_in_as(@test_teacher)
    get new_assignment_url, params: { course_id: 1 }
    assert_response :success
  end

  test "student cannot edit assignment" do
    log_in_as(@test_student)
    get edit_assignment_url(@assignment)
    assert_redirected_to dashboard_url
  end

  # test "should create assignment" do
  #   log_in_as(@test_teacher)
  #   assert_difference('Assignment.count') do
  #     course_id = Course.find_by(:course_code => '11a').id
  #     puts course_id
  #     post assignments_url, params: { assignment: { course_id: course_id,
  #                                                   due_date: @assignment.due_date, 
  #                                                   instructions: @assignment.instructions, 
  #                                                   template: @assignment.template, 
  #                                                   name: @assignment.name } }
  #   end
  #   assert_redirected_to assignment_url(Assignment.last)
  # end

  # test "should show assignment" do
  #   log_in_as(@test_student)
  #   get assignment_url(@assignment)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_assignment_url(@assignment)
  #   assert_response :success
  # end

  # test "should update assignment" do
  #   patch assignment_url(@assignment), params: { assignment: { course_id: @assignment.course_id, due_date: @assignment.due_date, instructions: @assignment.instructions, template: @assignment.template } }
  #   assert_redirected_to assignment_url(@assignment)
  # end

  # test "should destroy assignment" do
  #   assert_difference('Assignment.count', -1) do
  #     delete assignment_url(@assignment)
  #   end

  #   assert_redirected_to assignments_url
  # end
end
