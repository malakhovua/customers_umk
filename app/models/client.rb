class Client < ApplicationRecord
  has_many :orders
  has_many :favorite_products
end
