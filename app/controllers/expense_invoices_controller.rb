class ExpenseInvoicesController < ApplicationController
  before_action :set_expense_invoice, only: %i[ show edit update destroy ]

  # GET /expense_invoices or /expense_invoices.json
  def index

    unless helpers.current_user_admin
      @expense_invoices = ExpenseInvoice.joins(:access_group)
                     .where(access_group: helpers.current_user.access_group)
                     .order('doc_date DESC')
    else
      @expense_invoices = ExpenseInvoice.all.order('doc_date DESC')
    end

    @expense_invoices = @expense_invoices.where(:posted => true)
    
    # Фільтр по групі доступу
    @expense_invoices = @expense_invoices.where(access_group_id: params[:access_group_id]) if params[:access_group_id].present?

    # Фільтр по контрагенту
    @expense_invoices = @expense_invoices.where(client_id: params[:client_id]) if params[:client_id].present?

    # Фільтр по типу документу
    @expense_invoices = @expense_invoices.where(doc_type: params[:doc_type].to_i) if params[:doc_type].present?

    # Фільтр по даті (від)
    @expense_invoices = @expense_invoices.where("doc_date >= ?", params[:date_from]) if params[:date_from].present?

    # Фільтр по даті (до)
    @expense_invoices = @expense_invoices.where("doc_date <= ?", params[:date_to]) if params[:date_to].present?

    @expense_invoices = @expense_invoices.order(doc_date: :desc, id: :desc).page(params[:page])
  end

  # GET /expense_invoices/1 or /expense_invoices/1.json
  def show
  end

  # GET /expense_invoices/new
  def new
    @expense_invoice = ExpenseInvoice.new
  end

  # GET /expense_invoices/1/edit
  def edit
  end

  # POST /expense_invoices or /expense_invoices.json
  def create
    params[:expense_invoice][:doc_type] = params[:expense_invoice][:doc_type].to_i
    @expense_invoice = ExpenseInvoice.new(expense_invoice_params)

    respond_to do |format|
      if @expense_invoice.save
        format.html { redirect_to @expense_invoice, notice: "Видаткову накладну успішно створено." }
        format.json { render :show, status: :created, location: @expense_invoice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expense_invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expense_invoices/1 or /expense_invoices/1.json
  def update
    params[:expense_invoice][:doc_type] = params[:expense_invoice][:doc_type].to_i
    respond_to do |format|
      if @expense_invoice.update(expense_invoice_params)
        format.html { redirect_to @expense_invoice, notice: "Видаткову накладну успішно оновлено." }
        format.json { render :show, status: :ok, location: @expense_invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expense_invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expense_invoices/1 or /expense_invoices/1.json
  def destroy
    @expense_invoice.destroy
    respond_to do |format|
      format.html { redirect_to expense_invoices_url, notice: "Видаткову накладну успішно видалено." }
      format.json { head :no_content }
    end
  end

  private
  def set_expense_invoice
    @expense_invoice = ExpenseInvoice.find(params[:id])
  end

  def expense_invoice_params
    params.require(:expense_invoice).permit(:access_group_id, :client_id, :order_id, :doc_type, :sum, :retail_sum, :number, :doc_date, :comment)
  end
end