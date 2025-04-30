class InventoriesController < ApplicationController
  before_action :set_inventory, only: %i[ show edit update destroy ]
  before_action

  # GET /inventories or /inventories.json
  def index
    if session[:user_id]
      @inventories = if User.current_user.retailer?
                       Inventory.where(storage_place: User.current_user.storage_place).order(date: :desc, storage_place_id: :asc)
                     else
                       Inventory.all.order(date: :desc, storage_place_id:  :asc)
                     end
    end
  end

  # GET /inventories/1 or /inventories/1.json
  def show
  end

  # GET /inventories/new
  def new
    @inventory = Inventory.new
    @inventory.user = User.find_by(id: session[:user_id])
  end

  # GET /inventories/1/edit
  def edit
  end

  # POST /inventories or /inventories.json
  def create
    @inventory = Inventory.new(inventory_params)

    respond_to do |format|
      if @inventory.save
        format.html { redirect_to @inventory, notice: "Inventory was successfully created." }
        format.json { render :show, status: :created, location: @inventory }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventories/1 or /inventories/1.json
  def update

    @inventory.inventory_line_items.each do |line_item|
      line_item.rko = params["rko#{line_item.id}"].to_f
      line_item.qty = params["qty#{line_item.id}"].to_f
      line_item.sum = params["sum#{line_item.id}"].to_f
      line_item.product_name = params["product_name#{line_item.id}"].to_s
      line_item.comment = params["comment#{line_item.id}"].to_s
      line_item.save
    end
    @inventory.recalculate_total_sum

    respond_to do |format|

      if @inventory.update(inventory_params)
        format.html { redirect_to inventories_url, notice: 'Документ оновлено!' }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end

    end
  end

  # DELETE /inventories/1 or /inventories/1.json
  def destroy
    @inventory.destroy
    respond_to do |format|
      format.html { redirect_to inventories_url, notice: "Inventory was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_inventory
    @inventory = Inventory.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def inventory_params
    params.require(:inventory).permit(:storage_place_id, :user_id, :date, :desc)
  end
end
