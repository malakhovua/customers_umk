class InventoryLineItem < ApplicationRecord
  belongs_to :product
  belongs_to :inventory
  belongs_to :unit_product, optional: true
end
