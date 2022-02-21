class Client < ApplicationRecord
  has_many :orders
  has_many :favorite_products
  has_many :addresses
  has_many :asighnclients
  has_many :users, through: :asighnclients
  has_many :carts
  belongs_to :pricetype, optional: true
  belongs_to :access_group, optional: true
  has_many :product_exeptions
end
