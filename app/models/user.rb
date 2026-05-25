class User < ApplicationRecord
  has_many :values, dependent: :destroy
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  validates :name, presence: true, uniqueness: false, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  has_secure_password
  validates :password, length: { minimum: 6 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end
end