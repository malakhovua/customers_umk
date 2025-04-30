class InventoryLineItemsController < ApplicationController
  before_action :set_inventory_line_item, only: [:show, :edit, :update, :destroy]

  # GET /inventory_line_items or /inventory_line_items.json
  def index
    @inventory_line_items = InventoryLineItem.all
  end

  # GET /inventory_line_items/1 or /inventory_line_items/1.json
  def show
  end

  # GET /inventory_line_items/new
  def new
    @inventory_line_item = InventoryLineItem.new
  end

  # GET /inventory_line_items/1/edit
  def edit
  end

  # POST /inventory_line_items or /inventory_line_items.json
  def create
    @inventory_line_item = InventoryLineItem.new
    @inventory = Inventory.find(params[:inventory_id])
    @inventory_line_item.inventory = @inventory
    @inventory_line_item.qty = params['qty'].to_f
    @inventory_line_item.price = params['price'].to_f
    @inventory_line_item.sum = params['sum'].to_f
    @inventory_line_item.rko = params['rko'].to_i
    @inventory_line_item.comment = params['comment'].to_s
    @inventory_line_item.product_name = params['product_name'].to_s
    respond_to do |format|
      if @inventory_line_item.save
        @inventory.recalculate_total_sum
        @inventory.save
        format.html {redirect_to edit_inventory_path @inventory}
        format.js
      else
        format.html { render :create, status: :unprocessable_entity }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventory_line_items/1 or /inventory_line_items/1.json
  def update
    respond_to do |format|
      if @inventory_line_item.update(inventory_line_item_params)
        format.html { redirect_to @inventory_line_item, notice: "Inventory line item was successfully updated." }
        format.json { render :show, status: :ok, location: @inventory_line_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @inventory_line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventory_line_items/1 or /inventory_line_items/1.json
  def destroy
    @inventory = Inventory.find(@inventory_line_item.inventory_id)
    @inventory_line_item.destroy
    @inventory.recalculate_total_sum
    @inventory.save
    respond_to do |format|
      format.html {redirect_to edit_inventory_path @inventory}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_inventory_line_item
    @inventory_line_item = InventoryLineItem.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def inventory_line_item_params
    params.require(:inventory_line_item).permit(:qty, :price, :sum, :inventory_id, :comment, :units, :product_id)
  end
end
