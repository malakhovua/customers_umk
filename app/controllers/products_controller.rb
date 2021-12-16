class ProductsController < ApplicationController

  before_action :ensure_an_admin_role, :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    ensure_an_admin_role
    @products = Product.order(:parent_name).page params[:page]
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Продукция была успешно создана.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Продукция была успешно обновлена.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Продукция была удалена.' }
      format.json { head :no_content }
    end
  end

  def return_child_products

    @current_id = params[:current_id]
    level  =  params[:way] == "down" ? params[:level].to_i + 1 : params[:level].to_i - 1
    @level      = level
    @level_arr = params[:level_arr]
    @level_arr[level] = params[:current_id]

    respond_to do |format|
      format.html
      format.js
    end
  end

  def select_group_product
    @group_name = params[:group_name]
    @group_id = params[:group_id]
    respond_to do |format|
      format.html
      format.js
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :image_url, :price, :is_folder, :parent_id)
    end

end
