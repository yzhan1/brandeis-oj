class Assignment < ApplicationRecord
  validates :name, presence: true
  validates :due_date, presence: true
  validates :instructions, presence: true
  validates :template, presence: true
  validates :course_id, presence: true
  has_many :submissions
  belongs_to :course
end
