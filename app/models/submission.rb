class Submission < ApplicationRecord
  belongs_to :assignment
  belongs_to :user

  def run
    code = self.source_code
    dir_name = self.user.id
    mkdir = `cd code\nmkdir #{dir_name}`
    File.write("code/#{dir_name}/Solution.java", code)
    res = `cd code\ncd #{dir_name}\njavac Solution.java\n java Solution`
    remove = `rm -rf code/#{dir_name}`
    return res
  end
end
