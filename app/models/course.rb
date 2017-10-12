class Course < ApplicationRecord
  has_many :enrollments
  has_many :announcements
  has_many :assignments
end
