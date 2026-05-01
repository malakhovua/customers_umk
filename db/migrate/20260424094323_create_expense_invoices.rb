class CreateExpenseInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :expense_invoices do |t|
      t.references :access_group, foreign_key: true
      t.references :client, foreign_key: true
      t.references :order, foreign_key: true
      t.integer :doc_type
      t.float :sum
      t.float :retail_sum
      t.string :number
      t.datetime :doc_date
      t.string :comment

      t.timestamps
    end
  end
end
