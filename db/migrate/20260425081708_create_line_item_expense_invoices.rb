class CreateLineItemExpenseInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :line_item_expense_invoices do |t|
      t.references :product, foreign_key: true
      t.references :pack, foreign_key: true
      t.references :unit_product, foreign_key: true
      t.references :expense_invoice, foreign_key: true
      t.float :qty
      t.float :price
      t.float :retail_price
      t.float :sum
      t.float :retail_sum
      t.string :comment

      t.timestamps
    end
  end
end
