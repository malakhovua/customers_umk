class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show

  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:id])
    qty = params[:qty].to_f
    unit_id = params[:units].to_i

    unless params[:pack_id].nil?
      pack = Pack.find(params[:pack_id])
      @line_item = @cart.add_product(product, pack,qty,unit_id, pack.type_id)
    else
      @line_item = @cart.add_product(product,nil,qty,unit_id,0)
    end
    respond_to do |format|
      if @line_item.save
        format.html { redirect_to customer_index_url }
        format.js
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @cart = Cart.find(session[:cart_id])
    @line_item.destroy
    respond_to do |format|
      if @cart.total_quantity == 0.to_f
        @cart.destroy
        format.html { redirect_to customer_index_url, notice: 'Ваша корзина была полностью очищена.' }
      end
      format.html { redirect_to cart_path(@cart), notice: 'Строка удалена.' }
      format.json { head :no_content }
    end
  end

  def modal_product_qty
    @qty = 1
    @product_id = params[:id]
    @pack_id = params[:pack_id]
    @product_name = params[:product_name]
    @unit_id = Unit.find_by(name:params[:unit_name]).id
    @units_list = Unit.all
    @product = Product.all

    if params[:pack_name] != ""
         @product_name = @product_name + ' (' + params[:pack_name] + ')'
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_line_item
    @line_item = LineItem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def line_item_params
    params.require(:line_item).permit(:product_id, :pack_id)
  end
end
