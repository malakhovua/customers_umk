class ExpenseInvoice < ApplicationRecord
  belongs_to :access_group, optional: true
  belongs_to :client, optional: true
  belongs_to :order, optional: true

  has_many :line_item_expense_invoices, dependent: :destroy

  enum doc_type: %i[Продаж Повернення]
end
