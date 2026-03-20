class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  layout 'cart'


  # GET /carts
  # GET /carts.json
  def index
    ensure_an_admin_role
    @carts = Cart.all
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
  end

  # GET /carts/new
  def new

  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(cart_params)
    session[:client_id] = nil

    respond_to do |format|
      if @cart.save
        session[:cart_id] = @cart.id
        format.html { redirect_to customer_index_url}
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update

    if params[:data_type] == 'header'
      @cart.stick = !!params['stick']
      @cart.stick_pack = !!params['stick_pack']
    end

    if params[:data_type] == 'line_items'
      @lines_hash = Hash.new
      @cart.line_items.each do |line_item|
        line_item.pack = Pack.find(params['packs' + line_item.id.to_s]) unless params['packs' + line_item.id.to_s].nil?
        line_item.quantity = params['qty' + line_item.id.to_s].to_f
        line_item.amount = params['amount' + line_item.id.to_s].to_f
        line_item.stick = !!params['stick' + line_item.id.to_s]
        line_item.comment = params['comment' + line_item.id.to_s]
        line_item.recount = line_item.total_quantity
        line_item.save
        @lines_hash["item" + line_item.id.to_s] = [line_item.id.to_s, line_item.recount]
      end
    end

    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: 'Корзина була обновлена!' }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy

    redirect_path = carts_url

    @cart.destroy

    respond_to do |format|
      format.html { redirect_to redirect_path}
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cart
    @cart = Cart.find(params[:id])
    session[:cart_id] = @cart.id
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cart_params
    params.fetch(:cart, {})
  end

  private

  def invalid_cart
    logger.error "Attemp to access invalid cart #{params[:id]}"
    redirect_to customer_index_url, notice: 'Помилка доступу до кошика'

  end

end
