require 'open3'

class Submission < ApplicationRecord
  belongs_to :assignment
  belongs_to :user
  has_many :codes

  def run
    dir_name = user.id
    lang = self.assignment.lang
    `cd tmp\nmkdir #{dir_name}` # mkdir
    if lang == 'java'
      File.write("tmp/#{dir_name}/Solution.java", source_code)
      stdout_err, status = Open3.capture2e("cd tmp\ncd #{dir_name}\njavac Solution.java\njava Solution")
    elsif lang == 'python'
      File.write("tmp/#{dir_name}/solution.py", source_code)
      stdout_err, status = Open3.capture2e("cd tmp\ncd #{dir_name}\npython solution.py")
    elsif lang == 'ruby'
      File.write("tmp/#{dir_name}/solution.rb", source_code)
      stdout_err, status = Open3.capture2e("cd tmp\ncd #{dir_name}\nruby solution.rb")
    end
    `rm -rf tmp/#{dir_name}` # remove directory
    return stdout_err
  end

  def send_notification
    SubmissionMailer.grade_notification(self).deliver_now
  end
end
