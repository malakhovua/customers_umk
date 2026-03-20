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

# app/helpers/application_helper.rb
def datalist_with_details(collection, value_method, title_method)
  collection.map do |item|
    content_tag(:option, nil,
                value: item.send(value_method),
                title: item.send(title_method)
    )
  end.join.html_safe
end
