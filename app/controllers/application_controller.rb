class ApplicationController < ActionController::Base
  # helper :all

  private
  def ensure_an_admin_role
    unless helpers.current_user_admin
      redirect_to account_url
    end
  end
end