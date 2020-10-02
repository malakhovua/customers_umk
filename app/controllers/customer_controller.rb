class CustomerController < ApplicationController
  include CurrentCart
  before_action :set_cart

  def index
    @products = Product.where(:products => {is_folder:false}).order("parent_name").page params[:page]
  end

end
