require 'open3'

class Assignment < ApplicationRecord
  validates :name, presence: true
  validates :due_date, presence: true
  validates :instructions, presence: true
  validates :template, presence: true
  validates :course_id, presence: true
  has_many :submissions
  belongs_to :course
  has_attached_file :pdf_instruction
  validates_attachment_content_type :pdf_instruction, :content_type => ['application/pdf']

  def pass_due?
    Time.now > due_date ? true : false
  end

  # This is currently not finished
  # Ruby and Python have not been implemented
  def test_submission(lang, submission_id)
    # dir_name = user.id
    dir_name = "random-#{DateTime.now}-#{rand(10000)}"
    # puts "The dir name is #{dir_name}"
    submission = Submission.find(submission_id)
    mkdir = `cd tmp\nmkdir #{dir_name}`
    File.write("tmp/#{dir_name}/Solution.java", submission.source_code)
    if lang == 'java'
      `cp lib/assets/junit/junit-4.12.jar tmp/#{dir_name}\ncp lib/assets/junit/hamcrest-core-1.3.jar tmp/#{dir_name}\ncp lib/assets/junit/TestRunner.java tmp/#{dir_name}`
      File.write("tmp/#{dir_name}/JunitTests.java", test_code)
      stdout_err, status = Open3.capture2e("cd tmp\ncd #{dir_name}\njavac -cp .:junit-4.12.jar TestRunner.java\njavac -cp .:junit-4.12.jar JunitTests.java\njava -cp .:junit-4.12.jar:hamcrest-core-1.3.jar TestRunner")
    elsif lang == 'python'
      File.write("tmp/#{dir_name}/unit_tests.py", test_code)
      stdout_err, status = Open3.capture2e("cd tmp\ncd #{dir_name}\npython unit_tests.py")
    elsif lang == 'ruby'
      File.write("tmp/#{dir_name}/unit_tests.rb", test_code)
      stdout_err, status = Open3.capture2e("cd tmp\ncd #{dir_name}\nruby unit_tests.rb")
    end
    remove = `rm -rf tmp/#{dir_name}`
    return stdout_err
  end
end
