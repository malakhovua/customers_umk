json.extract! order, :id, :client_id, :date, :shipping_address, :user, :comments, :created_at, :updated_at
json.url order_url(order, format: :json)
