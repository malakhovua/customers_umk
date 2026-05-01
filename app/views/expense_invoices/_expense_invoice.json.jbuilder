json.extract! expense_invoice, :id, :access_groups_id, :client_id, :order_id, :type, :sum, :created_at, :updated_at
json.url expense_invoice_url(expense_invoice, format: :json)
