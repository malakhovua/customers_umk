class UnitProductsController < ApplicationController
  before_action :set_unit_product, only: %i[ show edit update destroy ]

  # GET /unit_products or /unit_products.json
  def index
    @unit_products = UnitProduct.all
  end

  # GET /unit_products/1 or /unit_products/1.json
  def show
  end

  # GET /unit_products/new
  def new
    @unit_product = UnitProduct.new
  end

  # GET /unit_products/1/edit
  def edit
  end

  # POST /unit_products or /unit_products.json
  def create
    @unit_product = UnitProduct.new(unit_product_params)

    respond_to do |format|
      if @unit_product.save
        format.html { redirect_to @unit_product, notice: "Unit product was successfully created." }
        format.json { render :show, status: :created, location: @unit_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @unit_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /unit_products/1 or /unit_products/1.json
  def update
    respond_to do |format|
      if @unit_product.update(unit_product_params)
        format.html { redirect_to @unit_product, notice: "Unit product was successfully updated." }
        format.json { render :show, status: :ok, location: @unit_product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @unit_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unit_products/1 or /unit_products/1.json
  def destroy
    @unit_product.destroy
    respond_to do |format|
      format.html { redirect_to unit_products_url, notice: "Unit product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit_product
      @unit_product = UnitProduct.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def unit_product_params
      params.require(:unit_product).permit(:name, :default, :product)
    end
end
