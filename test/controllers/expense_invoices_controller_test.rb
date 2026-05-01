require 'test_helper'

class ExpenseInvoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @expense_invoice = expense_invoices(:one)
  end

  test "should get index" do
    get expense_invoices_url
    assert_response :success
  end

  test "should get new" do
    get new_expense_invoice_url
    assert_response :success
  end

  test "should create expense_invoice" do
    assert_difference('ExpenseInvoice.count') do
      post expense_invoices_url, params: { expense_invoice: { access_groups_id: @expense_invoice.access_groups_id, client_id: @expense_invoice.client_id, order_id: @expense_invoice.order_id, sum: @expense_invoice.sum, type: @expense_invoice.type } }
    end

    assert_redirected_to expense_invoice_url(ExpenseInvoice.last)
  end

  test "should show expense_invoice" do
    get expense_invoice_url(@expense_invoice)
    assert_response :success
  end

  test "should get edit" do
    get edit_expense_invoice_url(@expense_invoice)
    assert_response :success
  end

  test "should update expense_invoice" do
    patch expense_invoice_url(@expense_invoice), params: { expense_invoice: { access_groups_id: @expense_invoice.access_groups_id, client_id: @expense_invoice.client_id, order_id: @expense_invoice.order_id, sum: @expense_invoice.sum, type: @expense_invoice.type } }
    assert_redirected_to expense_invoice_url(@expense_invoice)
  end

  test "should destroy expense_invoice" do
    assert_difference('ExpenseInvoice.count', -1) do
      delete expense_invoice_url(@expense_invoice)
    end

    assert_redirected_to expense_invoices_url
  end
end
