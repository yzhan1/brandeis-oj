require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase

  setup do
    @assignment = assignments(:one)
  end

  test "valid assignment" do
    assert @assignment.valid?
  end

  test "assignment must have due date" do
    course = Course.new(course_code: "11a", course_title: "Build web app", permission: "11a")
    assignment_test = Assignment.new(name: 'A new assignment', course: course, instructions: 'Do this and do that',
                template: 'public class Solution {}')
    refute assignment_test.valid?
    assert_not_nil assignment_test.errors[:due_date]
  end

end
