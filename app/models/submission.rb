require 'open3'

class Submission < ApplicationRecord
  belongs_to :assignment
  belongs_to :user

  def run
    dir_name = user.id
    mkdir = `cd tmp\nmkdir #{dir_name}`
    File.write("tmp/#{dir_name}/Solution.java", source_code)
    stdout_err, status = Open3.capture2e("cd tmp\ncd #{dir_name}\njavac Solution.java\njava Solution")
    remove = `rm -rf tmp/#{dir_name}`
    return stdout_err
  end
end
