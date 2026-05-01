class LineItemExpenseInvoicesController < ApplicationController
  before_action :set_line_item_expense_invoice, only: %i[ show edit update destroy ]

  # GET /line_item_expense_invoices or /line_item_expense_invoices.json
  def index
    @line_item_expense_invoices = LineItemExpenseInvoice.all
  end

  # GET /line_item_expense_invoices/1 or /line_item_expense_invoices/1.json
  def show
  end

  # GET /line_item_expense_invoices/new
  def new
    @line_item_expense_invoice = LineItemExpenseInvoice.new
  end

  # GET /line_item_expense_invoices/1/edit
  def edit
  end

  # POST /line_item_expense_invoices or /line_item_expense_invoices.json
  def create
    @line_item_expense_invoice = LineItemExpenseInvoice.new(line_item_expense_invoice_params)

    respond_to do |format|
      if @line_item_expense_invoice.save
        format.html { redirect_to @line_item_expense_invoice, notice: "Line item expense invoice was successfully created." }
        format.json { render :show, status: :created, location: @line_item_expense_invoice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @line_item_expense_invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_item_expense_invoices/1 or /line_item_expense_invoices/1.json
  def update
    respond_to do |format|
      if @line_item_expense_invoice.update(line_item_expense_invoice_params)
        format.html { redirect_to @line_item_expense_invoice, notice: "Line item expense invoice was successfully updated." }
        format.json { render :show, status: :ok, location: @line_item_expense_invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @line_item_expense_invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_item_expense_invoices/1 or /line_item_expense_invoices/1.json
  def destroy
    @line_item_expense_invoice.destroy
    respond_to do |format|
      format.html { redirect_to line_item_expense_invoices_url, notice: "Line item expense invoice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item_expense_invoice
      @line_item_expense_invoice = LineItemExpenseInvoice.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def line_item_expense_invoice_params
      params.require(:line_item_expense_invoice).permit(:product_id, :pack_id, :unit_product_id, :expense_invoice_id, :qty, :price, :retail_price, :sum, :retail_sum, :comment)
    end
end
