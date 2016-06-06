class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  attr_accessor :image_x, :image_y, :image_w, :image_h
  before_save   :downcase_email
  before_create :create_activation_digest, :create_attendance, :create_check_token
  validates :name, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :slack_channel, presence: true, length: { maximum: 30 }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  mount_uploader :user_icon, UserIconUploader
  mount_uploader :temp_icon, TempIconUploader
  validate :user_icon_size
  validates :comment, length: { maximum: 140 }
  has_one :attendance

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def update_check_token
    update_attribute(:check_token, User.new_token)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def update_image_infos(params)
    self.image_x = params[:image_x]
    self.image_y = params[:image_y]
    self.image_w = params[:image_w]
    self.image_h = params[:image_h]
  end

  private
  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
  end

  def create_attendance
    self.attendance = Attendance.new
  end

  def create_check_token
    self.check_token = User.new_token
  end

  def user_icon_size
    if user_icon.size > 5.megabytes
        errors.add(:user_icon, "should be less than 5MB")
    end
  end

end
