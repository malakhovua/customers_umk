json.extract! inventory_line_item, :id, :product_id, :qty, :price, :sum, :inventory_id, :created_at, :updated_at
json.url inventory_line_item_url(inventory_line_item, format: :json)
