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
      self.codes.each do |codeObj|
        File.write("tmp/#{dir_name}/#{codeObj.filename}", codeObj.source_code)
      end
      `cd tmp\ncd #{dir_name}\n`
      self.codes.each do |codeObj|
        `javac #{codeObj.filename}\n`
      end
      stdout_err, status = Open3.capture2e("java Solution")
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
    SubmissionMailer.grade_notification(self, current_user).deliver_now
  end
end
