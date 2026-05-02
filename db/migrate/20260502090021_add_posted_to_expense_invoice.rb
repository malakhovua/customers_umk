class AddPostedToExpenseInvoice < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_invoices, :posted, :boolean
    add_column :expense_invoices, :deletion_mark, :string
  end
end
