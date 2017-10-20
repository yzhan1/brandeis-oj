class Announcement < ApplicationRecord
  validates :name, presence: true
  validates :announcement_date, presence: true
  validates :announcement_body, presence: true
  belongs_to :course
end
