class Course < ApplicationRecord
  validates :course_title, presence: true
  validates :course_code, presence: true
  has_many :enrollments
  has_many :announcements
  has_many :assignments
  has_many :submissions, :through => :assignments
  has_many :users, :through => :enrollments

  def enrolled_user?(user)
    users.include?(user)
  end

  def has_assignment?(assignment)
    assignments.include?(assignment)
  end
end
