class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = I18n.t('users.flash.welcome')
      redirect_to work_path
    else
      render 'new'
    end
  end

  def results
    @user = User.find(params[:id])

    @user_values = @user.values.includes(:image).order(created_at: :desc)

    @grouped_by_theme = @user_values.group_by { |v| v.image.theme.name }
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end