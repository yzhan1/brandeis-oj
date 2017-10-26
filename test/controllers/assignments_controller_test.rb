require 'test_helper'

class AssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @test_teacher = users(:test_teacher)
    @test_student = users(:test_student)
    @assignment = assignments(:one)
  end

  test "should get new" do
    get new_assignment_url, params: { course_id: 1 }
    assert_response :success
  end

  test "should create assignment" do
    assert_difference('Assignment.count') do
      post assignments_url, params: { assignment: { course_id: @assignment.course_id, due_date: @assignment.due_date, instructions: @assignment.instructions, template: @assignment.template } }
    end

    assert_redirected_to assignment_url(Assignment.last)
  end

  test "should show assignment" do
    get assignment_url(@assignment)
    assert_response :success
  end

  test "should get edit" do
    get edit_assignment_url(@assignment)
    assert_response :success
  end

  test "should update assignment" do
    patch assignment_url(@assignment), params: { assignment: { course_id: @assignment.course_id, due_date: @assignment.due_date, instructions: @assignment.instructions, template: @assignment.template } }
    assert_redirected_to assignment_url(@assignment)
  end

  test "should destroy assignment" do
    assert_difference('Assignment.count', -1) do
      delete assignment_url(@assignment)
    end

    assert_redirected_to assignments_url
  end
end
