require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user = users(:test_student)
    @test_teacher = users(:test_teacher)
  end

  test 'valid student' do
    assert @user.valid?
  end

  test 'valid teacher' do
    assert @test_teacher.valid?
  end

  test 'invalid without email' do
    user = User.new(name: 'John')
    refute user.valid?
    assert_not_nil user.errors[:email]
  end
end
