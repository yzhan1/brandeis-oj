class Submission < ApplicationRecord
  belongs_to :assignment
  belongs_to :user
  belongs_to :course, :through => :assignment
end
