require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @test_teacher = users(:test_teacher)
    @test_student = users(:test_student)
    @test_teacher.enroll_course('11a')
    @test_student.enroll_course('11a')
    @course = courses(:course_one)
    @course_two = courses(:course_two)
  end

  test "student can view course he enrolled in" do
    log_in_as(@test_student)
    get course_url(@course)
    assert_response :success
  end

  test "student cannot view course without valid enrollment" do
    log_in_as(@test_student)
    get course_url(@course_two)
    assert_redirected_to error_url
  end

  test "teacher can view create page" do
    log_in_as(@test_teacher)
    get new_course_url
    assert_response :success
  end

  test "student cannot view create page" do
    log_in_as(@test_student)
    get new_course_url
    assert_redirected_to error_url
  end

  test "teacher can create course" do
    log_in_as(@test_teacher)
    assert_difference('Course.count') do
      post courses_url, params: { 
        course: { 
          course_code: @course.course_code, 
          course_title: @course.course_title
        } 
      }
    end
    assert_redirected_to course_url(Course.last)
  end

  test "student cannot create course" do
    log_in_as(@test_student)
    assert_difference('Course.count', 0) do
      post courses_url, params: { 
        course: { 
          course_code: @course.course_code, 
          course_title: @course.course_title
        } 
      }
    end
    assert_redirected_to error_url
  end

  test "teacher can get edit" do
    log_in_as(@test_teacher)
    get edit_course_url(@course)
    assert_response :success
  end

  test "student cannot get edit" do
    log_in_as(@test_student)
    get edit_course_url(@course)
    assert_redirected_to error_url
  end

  test "teacher can update course" do
    log_in_as(@test_teacher)
    patch course_url(@course), params: { 
      course: { 
        course_code: @course.course_code, 
        course_title: @course.course_title,
      } 
    }
    assert_redirected_to course_url(@course)
  end

  test "student cannot update course" do
    log_in_as(@test_student)
    patch course_url(@course), params: { 
      course: { 
        course_code: @course.course_code, 
        course_title: @course.course_title,
      } 
    }
    assert_redirected_to error_url
  end
end
