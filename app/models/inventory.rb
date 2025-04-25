class Inventory < ApplicationRecord
  belongs_to :storage_place, optional: true
  belongs_to :user, optional: true
  has_many :inventory_line_items, dependent: :destroy
end
