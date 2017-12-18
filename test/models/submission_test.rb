require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  setup do
    @assignment = assignments(:one)
    @submission = submissions(:submission_one)
  end

  test 'assignment valid' do
    assert @assignment.valid?
  end

  test 'submission valid' do
    assert @submission.valid?
  end

  test 'submission without user is invalid' do
    submission = Submission.new(source_code: 'Test code')
    refute submission.valid?
    assert_not_nil submission.errors[:user]
  end
end
