require 'test_helper'

class AssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @test_teacher = users(:test_teacher)
    @test_student = users(:test_student)
    @test_teacher.enroll_course('11a')
    @test_student.enroll_course('11a')
    @assignment = assignments(:one)
    @assignment_two = assignments(:assignment_two)
  end

  test "should get new" do
    log_in_as(@test_teacher)
    get new_assignment_url, params: { course_id: 1 }
    assert_response :success
  end

  test "student cannot edit assignment" do
    log_in_as(@test_student)
    get edit_assignment_url(@assignment)
    assert_redirected_to error_url
  end

  test "teacher can edit assignment" do
    log_in_as(@test_teacher)
    get edit_assignment_url(@assignment)
    assert_response :success
  end

  test "student can view assignment from course he enrolled in" do
    log_in_as(@test_student)
    get assignment_url(@assignment)
    assert_response :success
  end

  test "student cannot view assignment from other courses" do
    log_in_as(@test_student)
    get assignment_url(@assignment_two)
    assert_redirected_to error_url
  end

  test "should create assignment" do
    log_in_as(@test_teacher)
    course = nil
    assert_difference('Assignment.count') do
      course = Course.find_by(:course_code => '11a')
      post assignments_url, params: { 
        assignment: { 
          course_id: course.id,
          due_date: Time.now, 
          instructions: @assignment.instructions, 
          template: @assignment.template, 
          name: @assignment.name 
        } 
      }
    end
    assert_redirected_to course
  end

  test "should create announcement when posting new assignment" do
    log_in_as(@test_teacher)
    course = nil
    assert_difference('Announcement.count') do
      course = Course.find_by(:course_code => '11a')
      post assignments_url, params: { 
        assignment: { 
          course_id: course.id,
          due_date: Time.now, 
          instructions: @assignment.instructions, 
          template: @assignment.template, 
          name: @assignment.name 
        } 
      }
    end
    assert_redirected_to course
  end

  test "teacher cannot create assignment for course he doesn't teach" do
    log_in_as(@test_teacher)
    course = nil
    assert_difference('Assignment.count', 0) do
      course = Course.find_by(:course_code => '12b')
      post assignments_url, params: { 
        assignment: { 
          course_id: course.id,
          due_date: Time.now, 
          instructions: @assignment.instructions, 
          template: @assignment.template, 
          name: @assignment.name 
        } 
      }
    end
    assert_redirected_to error_url
  end

  test "should update assignment" do
    log_in_as(@test_teacher)
    patch assignment_url(@assignment), params: { 
      assignment: { 
        course_id: @assignment.course_id, 
        due_date: @assignment.due_date, 
        instructions: @assignment.instructions, 
        template: @assignment.template
      }
    }
    assert_redirected_to course_url(@assignment.course)
  end

  test "teacher cannot update assignment for course he doesn't teach" do
    log_in_as(@test_teacher)
    patch assignment_url(@assignment_two), params: { 
      assignment: { 
        course_id: @assignment.course_id, 
        due_date: @assignment.due_date, 
        instructions: @assignment.instructions, 
        template: @assignment.template
      }
    }
    assert_redirected_to error_url
  end

  test "teacher can delete assignment from course he teaches" do
    log_in_as(@test_teacher)
    course = @assignment.course
    assert_difference('Assignment.count', -1) do
      delete assignment_url(@assignment)
    end
    assert_redirected_to course
  end

  test "teacher cannot delete assignment from course he does not teach" do
    log_in_as(@test_teacher)
    assert_difference('Assignment.count', 0) do
      delete assignment_url(@assignment_two)
    end
    assert_redirected_to error_url
  end
end
