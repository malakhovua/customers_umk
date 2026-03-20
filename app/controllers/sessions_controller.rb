class SessionsController < ApplicationController
  skip_before_action :authorize

  layout 'login'

  def new
  end

  def create
    @user = User.find_by(name: params[:name])
    if @user.try(:authenticate, params[:password])
      session[:user_id] = @user.id
      set_current_user
      redirect_to account_url
    else
      redirect_to login_url, alert: "Невірне ім'я або пароль!"
    end

  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, notice: "Ви вийшли"
  end


end
