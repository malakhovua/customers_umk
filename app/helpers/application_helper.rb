module ApplicationHelper

    def current_user
      if session[:user_id]
        @current_user ||= User.find_by(id: session[:user_id])
      end
    end

    def current_user_admin
      current_user = User.find_by(id: session[:user_id])
      current_user.admin?
    end

end
