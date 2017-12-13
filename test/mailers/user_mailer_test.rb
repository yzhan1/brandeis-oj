require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  setup do
    @test_student = users(:test_student)
  end

  test "new account" do
    mail = UserMailer.welcome_email @test_student
    assert_equal "Welcome to AspirinX!", mail.subject
    assert_equal [@test_student.email], mail.to
    assert_equal ["no-reply@aspirinx.com"], mail.from
    assert_match @test_student.name, mail.body.encoded
  end
end
