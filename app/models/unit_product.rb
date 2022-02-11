class UnitProduct < ApplicationRecord
  belongs_to :product
  has_many :prices
end
