class ProductExeptionsController < ApplicationController
  before_action :set_product_exeption, only: %i[ show edit update destroy ]

  # GET /product_exeptions or /product_exeptions.json
  def index
    @product_exeptions = ProductExeption.all
  end

  # GET /product_exeptions/1 or /product_exeptions/1.json
  def show
  end

  # GET /product_exeptions/new
  def new
    @product_exeption = ProductExeption.new
  end

  # GET /product_exeptions/1/edit
  def edit
  end

  # POST /product_exeptions or /product_exeptions.json
  def create
    @product_exeption = ProductExeption.new(product_exeption_params)

    respond_to do |format|
      if @product_exeption.save
        format.html { redirect_to @product_exeption, notice: "Product exeption was successfully created." }
        format.json { render :show, status: :created, location: @product_exeption }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product_exeption.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_exeptions/1 or /product_exeptions/1.json
  def update
    respond_to do |format|
      if @product_exeption.update(product_exeption_params)
        format.html { redirect_to @product_exeption, notice: "Product exeption was successfully updated." }
        format.json { render :show, status: :ok, location: @product_exeption }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product_exeption.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_exeptions/1 or /product_exeptions/1.json
  def destroy
    @product_exeption.destroy
    respond_to do |format|
      format.html { redirect_to product_exeptions_url, notice: "Product exeption was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_exeption
      @product_exeption = ProductExeption.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_exeption_params
      params.require(:product_exeption).permit(:products_id, :clients_id)
    end
end
