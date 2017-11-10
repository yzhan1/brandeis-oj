require 'open3'

class Submission < ApplicationRecord
  belongs_to :assignment
  belongs_to :user
  has_many :codes

  def run lang, user_code
    dir_name = user.id
    mkdir = `cd tmp\nmkdir #{dir_name}`
    if lang == 'java'
      File.write("tmp/#{dir_name}/Solution.java", user_code)
      stdout_err, status = Open3.capture2e("cd tmp\ncd #{dir_name}\njavac Solution.java\njava Solution")
    elsif lang == 'python'
      File.write("tmp/#{dir_name}/solution.py", user_code)
      stdout_err, status = Open3.capture2e("cd tmp\ncd #{dir_name}\npython solution.py")
    elsif lang == 'ruby'
      File.write("tmp/#{dir_name}/solution.rb", user_code)
      stdout_err, status = Open3.capture2e("cd tmp\ncd #{dir_name}\nruby solution.rb")
    end
    remove = `rm -rf tmp/#{dir_name}`
    puts stdout_err
  end
end
