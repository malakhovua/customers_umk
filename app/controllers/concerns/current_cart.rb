module CurrentCart
  private

  def set_cart
    @cart ||= if session[:cart_id]
                Cart.find_by(id: session[:cart_id], user_id: helpers.current_user.id)
              end

    @cart ||= Cart.where(session_id: session.id.to_s, user_id: helpers.current_user.id)
                  .order(created_at: :desc)
                  .first_or_create

    session[:cart_id] = @cart.id
  end

  def current_cart
    session[:cart_id] = @cart.id
  end
end