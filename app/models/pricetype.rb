class Pricetype < ApplicationRecord
  has_many :price
  has_many :client
end
