class Order < ApplicationRecord
  belongs_to :client
  belongs_to :user
  has_many :line_items, dependent: :destroy

  paginates_per 20
  max_paginates_per 20



  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
       item.cart_id  = nil
      line_items  <<  item
    end
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price (item.product.id)}
  end

  def total_quantity
    line_items.to_a.sum { |item| item.total_quantity }
  end

end
