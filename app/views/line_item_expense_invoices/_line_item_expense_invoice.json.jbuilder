json.extract! line_item_expense_invoice, :id, :product_id, :pack_id, :unit_product_id, :expense_invoice_id, :qty, :price, :retail_price, :sum, :retail_sum, :comment, :created_at, :updated_at
json.url line_item_expense_invoice_url(line_item_expense_invoice, format: :json)
