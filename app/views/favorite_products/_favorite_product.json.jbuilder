json.extract! favorite_product, :id, :user_id, :product_id, :created_at, :updated_at
json.url favorite_product_url(favorite_product, format: :json)
