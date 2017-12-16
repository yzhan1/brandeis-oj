require 'test_helper'

class SubmissionMailerTest < ActionMailer::TestCase
  setup do
    @test_student = users(:test_student)
    @test_teacher = users(:test_teacher)
    @submission = submissions(:submission_one)
  end

  test "grade notification" do
    mail = SubmissionMailer.grade_notification @submission, @test_teacher
    assert_equal "#{@test_teacher.name} has given grade for your submission to assignment #{@submission.assignment.name}", mail.subject
    assert_equal [@test_student.email], mail.to
    assert_equal ["no-reply@aspirinx.com"], mail.from
  end
end
