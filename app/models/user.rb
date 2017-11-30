class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@brandeis.edu/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  validates :role, presence: true
  has_many :submissions
  has_many :enrollments
  has_many :courses, through: :enrollments

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def enroll_course permission
    course_list = Course.where(permission: permission)
    if !course_list.nil? && !course_list.first.nil?
      course = course_list.first
      enrollments << Enrollment.new(course_id: course.id)
    else
      false
    end
  end

  def submissions_for assignments
    submissions.where(submitted: true, assignment_id: assignments.ids)
  end

  def self.from_omniauth auth
    where(oauth_provider: auth.provider, oauth_uid: auth.uid).first_or_initialize.tap do |user|
      return nil if auth.extra.raw_info.hd != 'brandeis.edu'
      user.email = auth.info.email
      user.name = auth.info.name
      user.profile_pic = auth.info.image
      user.oauth_provider = auth.provider
      user.oauth_uid = auth.uid
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at auth.credentials.expires_at
      user.password = user.password_confirmation = User.new_token
      user.password_digest = User.new_token
      user.role = set_role user.email
      return user
    end
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end

  private 

  def self.set_role email
    File.readlines('db/instructor_email.csv').each do |line|
      return 'teacher' if email == line
    end
    'student'
  end
end
