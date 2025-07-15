class InventoriesController < ApplicationController
  before_action :set_inventory, only: %i[ show edit update destroy ]
  before_action

  # GET /inventories or /inventories.json
  def index

    unless session[:inventory_index_params].nil?
      params['storage_place'] = session[:inventory_index_params]['storage_place'] if params['storage_place'].nil?
      params['user'] = session[:inventory_index_params]['user'] if params['user'].nil?
      params['current_date'] = session[:inventory_index_params]['current_date'] if params['current_date'].nil?
      params['inv_types'] = session[:inventory_index_params]['inv_types'] if params['inv_types'].nil?
      params['status'] = session[:inventory_index_params]['status'] if params['status'].nil?
      # params['page'] = session[:inventory_index_page] if params['page'].nil?
    end

    if session[:user_id]
      @inventories = if User.current_user.retailer?
                       Inventory.where(storage_place: User.current_user.storage_place)
                     else
                       Inventory.all
                     end

      @inventories = @inventories.where(storage_place: params['storage_place']) if params['storage_place'].present?

      @inventories = @inventories.where(user: params['user']) if params['user'].present?

      @inventories = @inventories.where(date: params['current_date']) if params['current_date'].present?

      @inventories = @inventories.where(inv_type: params['inv_types']) if params['inv_types'].present?

      @inventories = @inventories.where(status: params['status']) if params['status'].present?

      @inventories = @inventories.order(date: :desc, storage_place_id: :asc).page(params[:page])

      session[:inventory_index_params] = params
      # session[:inventory_index_page] = params[:page]

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
        format.html { redirect_to @inventory, notice: "Інвентаризацію було створено." }
        format.json { render :show, status: :created, location: @inventory }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventories/1 or /inventories/1.json
  def update

    params[:inventory][:status] = params[:inventory][:status].to_i

    @inventory.inventory_line_items.each do |line_item|
      line_item.rko = params["rko#{line_item.id}"].to_f
      line_item.qty = params["qty#{line_item.id}"].to_f
      line_item.sum = params["sum#{line_item.id}"].to_f
      line_item.product_name = params["product_name#{line_item.id}"].to_s
      line_item.comment = params["comment#{line_item.id}"].to_s
      line_item.checked = !!params["checked#{line_item.id}"]
      line_item.save
    end
    @inventory.recalculate_total_sum
    respond_to do |format|

      if @inventory.update(inventory_params)
        @inventory.status = params[:status].to_i
        format.html { redirect_to edit_inventory_path @inventory}
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
      format.html { redirect_to inventories_url, notice: "Інвентаризацію було видалено." }
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
    params.require(:inventory).permit(:storage_place_id, :user_id, :date, :desc, :status)
  end
end
