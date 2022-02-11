class OrdersController < ApplicationController

  include CurrentCart

  before_action :set_cart

  before_action :ensure_cart_isnt_empty, only: :new
  before_action :initialize_collections, only: [:new, :create, :update]
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    unless helpers.current_user_admin
      @orders = Order.all.order('id DESC').where("user_id = #{helpers.current_user.id}").page params[:page]
    else
      @orders = Order.all.order('id DESC').page params[:page]
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    if @cart.client_id.nil?
      respond_to do |format|
        format.html { redirect_to @cart,
                                  notice: 'выберите покупателя.' }
      end
      return
    end
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(@cart)
    @order.stick = @cart.stick
    @order.stick_pack = @cart.stick_pack
    @order.client_id = @cart.client_id

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        OrderMailer.received(@order).deliver_later
        format.html { redirect_to customer_index_url,
                                  notice: 'Благодарим за Ваш заказ.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_clients_to_user

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def initialize_collections
    @clients = Client.all
  end

  def ensure_cart_isnt_empty
    if @cart.line_items.empty?
      redirect_to customer_index_url, notice: 'Ваша корзина пуста'
    end
  end

  def set_order
    @order = Order.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    user = User.find_by(id: session[:user_id])
    params.require(:order).permit(:client_id, :date, :shipping_address, :comments, :address_id).merge!({ user: user })
  end
end
