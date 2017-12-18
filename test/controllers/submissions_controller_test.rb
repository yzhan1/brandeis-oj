require 'test_helper'

class SubmissionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @test_teacher = users(:test_teacher)
    @test_student = users(:test_student)
    @another_student = users(:another_student)
    @test_teacher.enroll_course('11a')
    @test_student.enroll_course('11a')
    @assignment = assignments(:one)
    @assignment_two = assignments(:assignment_two)
    @submission = submissions(:submission_one)
    @submission_two = submissions(:submission_two)
  end

  test "should show submission" do
    log_in_as(@test_student)
    get submission_url(@submission)
    assert_response :success
  end

  test "should create new submission when solving assignment for first time" do
    log_in_as(@test_student)
    @test_student.enroll_course('12b')
    assert_difference('Submission.count') do
      get assignment_url(@assignment_two)
    end
    assert_response :success
  end

  test "should not show submission from others" do
    log_in_as(@another_student)
    get submission_url(@submission)
    assert_redirected_to error_url
  end

  test "teacher can see submission" do
    log_in_as(@test_teacher)
    get submission_url(@submission)
    assert_response :success
  end

  test "should submit submission if not passed due yet" do
    log_in_as(@test_student)
    patch save_url, params: {
      run: 0,
      submission: {
        id: @submission.id,
        assignment_id: @submission.assignment.id,
        user_id: @test_student.id,
        code: {
          source_code: "hello"
        }
      }
    }
    assert_redirected_to course_url(@submission.assignment.course)
  end

  test "should not submit submission if passed due" do
    log_in_as(@test_student)
    patch save_url, params: {
      run: 0,
      submission: {
        id: @submission_two.id,
        assignment_id: @submission_two.assignment.id,
        user_id: @test_student.id,
        code: {
          source_code: "hello"
        }
      }
    }
    assert_equal @submission_two.submitted, false
    assert_redirected_to course_url(@submission_two.assignment.course)
  end
end
