module SessionsHelper

  # Вход пользователя (устанавливаем куку и текущего пользователя)
  def sign_in(user)
    # Генерируем новый токен
    remember_token = User.new_remember_token
    # Сохраняем хэш токена в БД
    user.update_attribute(:remember_token, User.digest(remember_token))
    # Устанавливаем куку с сырым токеном (срок жизни 20 лет, можно настроить)
    cookies.permanent[:remember_token] = remember_token
    # Устанавливаем текущего пользователя
    self.current_user = user
  end

  # Возвращает true, если пользователь вошёл
  def signed_in?
    !current_user.nil?
  end

  # Текущий пользователь (кэшируется)
  def current_user
    @current_user ||= User.find_by(remember_token: User.digest(cookies[:remember_token])) if cookies[:remember_token]
  end

  # Присвоение текущего пользователя (сеттер)
  def current_user=(user)
    @current_user = user
  end

  # Выход пользователя
  def sign_out
    # Обнуляем токен в БД
    current_user&.update_attribute(:remember_token, nil)
    # Удаляем куку
    cookies.delete(:remember_token)
    # Очищаем переменную
    self.current_user = nil
  end
end