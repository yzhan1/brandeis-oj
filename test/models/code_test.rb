require 'test_helper'

class CodeTest < ActiveSupport::TestCase

  test "Code is invalid without submission id" do
    code = Code.new(source_code: 'test', filename: 'file')
    code.valid?
    assert_not_nil code.errors[:submission_id]
  end
end
