class LineItemExpenseInvoice < ApplicationRecord
  belongs_to :product, optional: true
  belongs_to :pack, optional: true
  belongs_to :unit_product, optional: true
  belongs_to :expense_invoice
end
