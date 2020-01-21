class AccountController < ApplicationController
  include CurrentCart
  before_action :set_cart
  def index
    @carts = Cart.all
  end
end
