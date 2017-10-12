class Assignment < ApplicationRecord
  has_many :submissions
  belongs_to :course
end
