require 'test_helper'

class LineItemExpenseInvoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item_expense_invoice = line_item_expense_invoices(:one)
  end

  test "should get index" do
    get line_item_expense_invoices_url
    assert_response :success
  end

  test "should get new" do
    get new_line_item_expense_invoice_url
    assert_response :success
  end

  test "should create line_item_expense_invoice" do
    assert_difference('LineItemExpenseInvoice.count') do
      post line_item_expense_invoices_url, params: { line_item_expense_invoice: { comment: @line_item_expense_invoice.comment, expense_invoice_id: @line_item_expense_invoice.expense_invoice_id, pack_id: @line_item_expense_invoice.pack_id, price: @line_item_expense_invoice.price, product_id: @line_item_expense_invoice.product_id, qty: @line_item_expense_invoice.qty, retail_price: @line_item_expense_invoice.retail_price, retail_sum: @line_item_expense_invoice.retail_sum, sum: @line_item_expense_invoice.sum, unit_product_id: @line_item_expense_invoice.unit_product_id } }
    end

    assert_redirected_to line_item_expense_invoice_url(LineItemExpenseInvoice.last)
  end

  test "should show line_item_expense_invoice" do
    get line_item_expense_invoice_url(@line_item_expense_invoice)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_expense_invoice_url(@line_item_expense_invoice)
    assert_response :success
  end

  test "should update line_item_expense_invoice" do
    patch line_item_expense_invoice_url(@line_item_expense_invoice), params: { line_item_expense_invoice: { comment: @line_item_expense_invoice.comment, expense_invoice_id: @line_item_expense_invoice.expense_invoice_id, pack_id: @line_item_expense_invoice.pack_id, price: @line_item_expense_invoice.price, product_id: @line_item_expense_invoice.product_id, qty: @line_item_expense_invoice.qty, retail_price: @line_item_expense_invoice.retail_price, retail_sum: @line_item_expense_invoice.retail_sum, sum: @line_item_expense_invoice.sum, unit_product_id: @line_item_expense_invoice.unit_product_id } }
    assert_redirected_to line_item_expense_invoice_url(@line_item_expense_invoice)
  end

  test "should destroy line_item_expense_invoice" do
    assert_difference('LineItemExpenseInvoice.count', -1) do
      delete line_item_expense_invoice_url(@line_item_expense_invoice)
    end

    assert_redirected_to line_item_expense_invoices_url
  end
end
