require "application_system_test_case"

class ExpenseInvoicesTest < ApplicationSystemTestCase
  setup do
    @expense_invoice = expense_invoices(:one)
  end

  test "visiting the index" do
    visit expense_invoices_url
    assert_selector "h1", text: "Expense Invoices"
  end

  test "creating a Expense invoice" do
    visit expense_invoices_url
    click_on "New Expense Invoice"

    fill_in "Access groups", with: @expense_invoice.access_groups_id
    fill_in "Client", with: @expense_invoice.client_id
    fill_in "Order", with: @expense_invoice.order_id
    fill_in "Sum", with: @expense_invoice.sum
    fill_in "Type", with: @expense_invoice.type
    click_on "Create Expense invoice"

    assert_text "Expense invoice was successfully created"
    click_on "Back"
  end

  test "updating a Expense invoice" do
    visit expense_invoices_url
    click_on "Edit", match: :first

    fill_in "Access groups", with: @expense_invoice.access_groups_id
    fill_in "Client", with: @expense_invoice.client_id
    fill_in "Order", with: @expense_invoice.order_id
    fill_in "Sum", with: @expense_invoice.sum
    fill_in "Type", with: @expense_invoice.type
    click_on "Update Expense invoice"

    assert_text "Expense invoice was successfully updated"
    click_on "Back"
  end

  test "destroying a Expense invoice" do
    visit expense_invoices_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Expense invoice was successfully destroyed"
  end
end
