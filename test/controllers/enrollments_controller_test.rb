require 'test_helper'

class EnrollmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @test_teacher = users(:test_teacher)
    @test_student = users(:test_student)
    @course = courses(:course_one)
    @course_two = courses(:course_two)
  end

  test "should enroll in course with valid enrollment string" do
    log_in_as @test_student
    assert_difference('Enrollment.count') do
      post enroll_url, params: {
        enrollment: { course_id: '11a' }
      }
    end
    assert_redirected_to dashboard_url
  end

  test "should not enroll when not logged in" do
    post enroll_url, params: {
      enrollment: { course_id: '11a' }
    }
    assert_redirected_to login_url
  end
end
