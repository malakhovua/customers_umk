class Pricetype < ApplicationRecord
  has_many :price
  has_many :client

  attribute :ignore_empty_prices, :boolean, default: false
end
