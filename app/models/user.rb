class User < ApplicationRecord
  has_many :values, dependent: :destroy
  before_save { self.email = email.downcase }            # приводим email к нижнему регистру
  before_create :create_remember_token                  # генерируем токен при создании

  validates :name, presence: true, uniqueness: false, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 },
            format: { with: URI::MailTo::EMAIL_REGEXP }  # простой regexp для email

  has_secure_password                                    # добавляет аутентификацию по паролю
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Генерация нового токена (классовый метод)
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  # Хэширование токена (для хранения в БД)
  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

  # Генерируем remember_token перед созданием записи
  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end
end