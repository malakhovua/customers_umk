class FavoriteProductsController < ApplicationController
  before_action :set_favorite_product, only: [:show, :edit, :update, :destroy]

  # GET /favorite_products
  # GET /favorite_products.json
  def index
    @favorite_products = FavoriteProduct.all
  end

  # GET /favorite_products/1
  # GET /favorite_products/1.json
  def show
  end

  # GET /favorite_products/new
  def new
    @favorite_product = FavoriteProduct.new
  end

  # GET /favorite_products/1/edit
  def edit
  end

  # POST /favorite_products
  # POST /favorite_products.json
  def create

    @favorite_product = FavoriteProduct.find_by(product_id: favorite_product_params["product_id"],
                                                user_id: favorite_product_params["user_id"],
                                                client_id: favorite_product_params["client_id"] )

    if favorite_product_params["client_id"] == ""
      format.html { redirect_to request.referer, alert: 'Message sent!' }
      return
    end

    @heard_id = "heard_"+favorite_product_params["product_id"]
    unless @favorite_product.nil?
      @favorite_product.destroy
      @create = false
    else
      @favorite_product = FavoriteProduct.new(favorite_product_params)
      @create = true
    end
    respond_to do |format|
      if @favorite_product.save
        format.html { redirect_to customer_index_url, notice: 'Товар добовлен в избранное!' }
        format.js
        format.json { render :show, status: :created, location: @favorite_product }
      else
        format.html { redirect_to customer_index_url, notice: 'Товар добовлен в избранное!' }
        format.js
        format.json { render json: @favorite_product.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /favorite_products/1
  # PATCH/PUT /favorite_products/1.json
  def update
    respond_to do |format|
      if @favorite_product.update(favorite_product_params)
        format.html { redirect_to @favorite_product, notice: 'Favorite product was successfully updated.' }
        format.json { render :show, status: :ok, location: @favorite_product }
      else
        format.html { render :edit }
        format.json { render json: @favorite_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /favorite_products/1
  # DELETE /favorite_products/1.json
  def destroy
    @favorite_product.destroy
    respond_to do |format|
      format.html { redirect_to favorite_products_url, notice: 'Favorite product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_favorite_product
    @favorite_product = FavoriteProduct.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def favorite_product_params
    params.require(:favorite_product).permit(:user_id, :product_id, :client_id)
  end
end
