class Pricetype < ApplicationRecord
  has_many :price
  belongs_to :client
end
