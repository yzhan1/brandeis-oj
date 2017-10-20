class Course < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :announcements
  has_many :assignments
  has_many :submissions, :through => :assignments, dependent: :destroy
  has_many :users, :through => :enrollments

  def enrolled_user?(user)
    users.include?(user)
  end

  def has_assignment?(assignment)
    assignments.include?(assignment)
  end
end
