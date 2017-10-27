class Submission < ApplicationRecord
  belongs_to :assignment
  belongs_to :user

  def run
    code = self.source_code
    dir_name = self.user.id
    mkdir = `cd tmp\nmkdir #{dir_name}`
    File.write("tmp/#{dir_name}/Solution.java", code)
    res = `cd tmp\ncd #{dir_name}\njavac Solution.java\n java Solution`
    remove = `rm -rf tmp/#{dir_name}`
    return res
  end
end
