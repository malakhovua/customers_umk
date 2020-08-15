class PricetypesController < ApplicationController
  before_action :set_pricetype, only: [:show, :edit, :update, :destroy]

  # GET /pricetypes
  # GET /pricetypes.json
  def index
    @pricetypes = Pricetype.all
  end

  # GET /pricetypes/1
  # GET /pricetypes/1.json
  def show
  end

  # GET /pricetypes/new
  def new
    @pricetype = Pricetype.new
  end

  # GET /pricetypes/1/edit
  def edit
  end

  # POST /pricetypes
  # POST /pricetypes.json
  def create
    @pricetype = Pricetype.new(pricetype_params)

    respond_to do |format|
      if @pricetype.save
        format.html { redirect_to @pricetype, notice: 'Pricetype was successfully created.' }
        format.json { render :show, status: :created, location: @pricetype }
      else
        format.html { render :new }
        format.json { render json: @pricetype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pricetypes/1
  # PATCH/PUT /pricetypes/1.json
  def update
    respond_to do |format|
      if @pricetype.update(pricetype_params)
        format.html { redirect_to @pricetype, notice: 'Pricetype was successfully updated.' }
        format.json { render :show, status: :ok, location: @pricetype }
      else
        format.html { render :edit }
        format.json { render json: @pricetype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pricetypes/1
  # DELETE /pricetypes/1.json
  def destroy
    @pricetype.destroy
    respond_to do |format|
      format.html { redirect_to pricetypes_url, notice: 'Pricetype was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pricetype
      @pricetype = Pricetype.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pricetype_params
      params.require(:pricetype).permit(:name)
    end
end
