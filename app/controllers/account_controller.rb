class AccountController < ApplicationController
  include CurrentCart
  def index
    @carts = Cart.all
  end
end
