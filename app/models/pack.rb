class Pack < ApplicationRecord
  belongs_to :product, optional: true
  belongs_to :price, optional: true
  has_many :line_items
end
