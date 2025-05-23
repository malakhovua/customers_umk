class ApplicationController < ActionController::Base

  helper :all

  before_action :authorize, :set_current_user

  protected

  def ensure_an_admin_role
    unless helpers.current_user_admin
      redirect_to account_url
    end
  end

  def authorize
    unless User.find_by(id: session[:user_id])
      redirect_to login_url, notice: "Пожалуйста залогинтесь."
    else
    end
  end

  private

  def set_current_user
    Current.user = User.find_by(id: session[:user_id])
  end

end