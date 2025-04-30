class InventoryLineItem < ApplicationRecord
  belongs_to :product, optional: true
  belongs_to :inventory
  belongs_to :unit_product, optional: true
end
