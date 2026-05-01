require "application_system_test_case"

class LineItemExpenseInvoicesTest < ApplicationSystemTestCase
  setup do
    @line_item_expense_invoice = line_item_expense_invoices(:one)
  end

  test "visiting the index" do
    visit line_item_expense_invoices_url
    assert_selector "h1", text: "Line Item Expense Invoices"
  end

  test "creating a Line item expense invoice" do
    visit line_item_expense_invoices_url
    click_on "New Line Item Expense Invoice"

    fill_in "Comment", with: @line_item_expense_invoice.comment
    fill_in "Expense invoice", with: @line_item_expense_invoice.expense_invoice_id
    fill_in "Pack", with: @line_item_expense_invoice.pack_id
    fill_in "Price", with: @line_item_expense_invoice.price
    fill_in "Product", with: @line_item_expense_invoice.product_id
    fill_in "Qty", with: @line_item_expense_invoice.qty
    fill_in "Retail price", with: @line_item_expense_invoice.retail_price
    fill_in "Retail sum", with: @line_item_expense_invoice.retail_sum
    fill_in "Sum", with: @line_item_expense_invoice.sum
    fill_in "Unit product", with: @line_item_expense_invoice.unit_product_id
    click_on "Create Line item expense invoice"

    assert_text "Line item expense invoice was successfully created"
    click_on "Back"
  end

  test "updating a Line item expense invoice" do
    visit line_item_expense_invoices_url
    click_on "Edit", match: :first

    fill_in "Comment", with: @line_item_expense_invoice.comment
    fill_in "Expense invoice", with: @line_item_expense_invoice.expense_invoice_id
    fill_in "Pack", with: @line_item_expense_invoice.pack_id
    fill_in "Price", with: @line_item_expense_invoice.price
    fill_in "Product", with: @line_item_expense_invoice.product_id
    fill_in "Qty", with: @line_item_expense_invoice.qty
    fill_in "Retail price", with: @line_item_expense_invoice.retail_price
    fill_in "Retail sum", with: @line_item_expense_invoice.retail_sum
    fill_in "Sum", with: @line_item_expense_invoice.sum
    fill_in "Unit product", with: @line_item_expense_invoice.unit_product_id
    click_on "Update Line item expense invoice"

    assert_text "Line item expense invoice was successfully updated"
    click_on "Back"
  end

  test "destroying a Line item expense invoice" do
    visit line_item_expense_invoices_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Line item expense invoice was successfully destroyed"
  end
end
