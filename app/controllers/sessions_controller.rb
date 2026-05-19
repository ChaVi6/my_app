class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    user = User.find_by(email: email)

    if user.nil?
      flash.now[:alert] = I18n.t('sessions.flash.user_not_found', email: email)
      render 'new'
    elsif !user.authenticate(password)
      flash.now[:alert] = I18n.t('sessions.flash.invalid_password', email: email)
      render 'new'
    else
      sign_in user
      redirect_to work_path
    end
  end
  def destroy
    sign_out
    redirect_to root_path
  end
end