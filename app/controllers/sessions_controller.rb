class SessionsController < ApplicationController
  skip_before_action :authorize

  def new
  end

  def create
    @user = User.find_by(name: params[:name])
    if @user.try(:authenticate, params[:password])
      session[:user_id] = @user.id
      set_current_user
      redirect_to account_url
    else
      redirect_to login_url, alert: "Неверное имя или пароль!"
    end

  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, notice: "Logged out"
  end


end
