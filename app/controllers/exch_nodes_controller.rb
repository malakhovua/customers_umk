class ExchNodesController < ApplicationController
  before_action :set_exch_node, only: [:show, :edit, :update, :destroy]

  # GET /exch_nodes
  # GET /exch_nodes.json
  def index
    ensure_an_admin_role
    @exch_nodes = ExchNode.all
  end

  # GET /exch_nodes/1
  # GET /exch_nodes/1.json
  def show
  end

  # GET /exch_nodes/new
  def new
    @exch_node = ExchNode.new
  end

  # GET /exch_nodes/1/edit
  def edit
  end

  # POST /exch_nodes
  # POST /exch_nodes.json
  def create
    @exch_node = ExchNode.new(exch_node_params)

    respond_to do |format|
      if @exch_node.save
        format.html { redirect_to @exch_node, notice: 'Exch node was successfully created.' }
        format.json { render :show, status: :created, location: @exch_node }
      else
        format.html { render :new }
        format.json { render json: @exch_node.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exch_nodes/1
  # PATCH/PUT /exch_nodes/1.json
  def update
    respond_to do |format|
      if @exch_node.update(exch_node_params)
        format.html { redirect_to @exch_node, notice: 'Exch node was successfully updated.' }
        format.json { render :show, status: :ok, location: @exch_node }
      else
        format.html { render :edit }
        format.json { render json: @exch_node.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exch_nodes/1
  # DELETE /exch_nodes/1.json
  def destroy
    @exch_node.destroy
    respond_to do |format|
      format.html { redirect_to exch_nodes_url, notice: 'Exch node was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exch_node
      @exch_node = ExchNode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exch_node_params
      params.require(:exch_node).permit(:node, :ser, :cat, :code_unf)
    end
end
