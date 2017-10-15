class Course < ApplicationRecord
  has_many :enrollments
  has_many :announcements
  has_many :assignments
  has_many :submissions, :through => :assignments
end
