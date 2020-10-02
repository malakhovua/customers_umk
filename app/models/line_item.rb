class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product, optional: true
  belongs_to :pack, optional: true
  belongs_to :cart

  def total_price (product_id)
    Product.get_price(product_id) * quantity
  end

  def total_quantity
    quantity
  end
end
