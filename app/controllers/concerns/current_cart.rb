module CurrentCart
  private

  def set_cart
    @cart = Cart.where(session_id: session.id.to_s, user_id: helpers.current_user.id).order(created_at: :desc).first ||
            Cart.create(session_id: session.id.to_s, user_id: helpers.current_user.id)

    session[:cart_id] = @cart.id
  end

  def current_cart
    session[:cart_id] = @cart.id
  end


end