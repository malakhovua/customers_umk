class AccountController < ApplicationController
  def index
    @carts = Cart.all
  end
end
