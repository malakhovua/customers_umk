class AdminController < ApplicationController

  before_action :ensure_an_admin_role

  def index
    ensure_an_admin_role
  end

  def products_1c83
    exchenge = Unf.new
    exchenge.get_products
    respond_to do |format|
      format.js
    end
  end

  def packs_1c83
    exchenge = Unf.new
    exchenge.get_packs
    respond_to do |format|
      format.js
    end
  end

  def clients_1c83
    exchenge = Unf.new
    exchenge.get_clients
    respond_to do |format|
      format.js
    end
  end

  def pricetypes_1c83
    exchenge = Unf.new
    exchenge.get_price_types
    respond_to do |format|
      format.js
    end
  end

  def prices_1c83
    exchenge = Unf.new
    exchenge.get_prices
    respond_to do |format|
      format.js
    end
  end

  def addresses_1c83
    exchenge = Unf.new
    exchenge.get_addresses
    respond_to do |format|
      format.js
    end
  end


  def orders_to_1c83
    date1 = params['date1']['date_1'].to_time
    date2 = params['date2']['date_2'].to_time
    exchenge = Unf.new
    exchenge.post_orders(date1, date2)
    @orders = Order.all
    respond_to do |format|
      format.js
    end
  end

  private

  def orders_params
    params.require(:data).permit(:data_1, :data_2)
  end

end
