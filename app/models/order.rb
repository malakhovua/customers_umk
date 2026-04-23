class Order < ApplicationRecord
  belongs_to :client
  belongs_to :address, optional: true
  belongs_to :user
  has_many :line_items, dependent: :destroy

  paginates_per 20
  max_paginates_per 20

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
       item.cart_id  = nil
       price_type =  cart.user&.pricetype ||  cart.client&.pricetype
       item.price     = Product.get_price(item.product.id, price_type, item.pack.nil? ? nil : item.pack.id,nil, self.date)
       item.weight_price     = Product.get_price(item.product.id, price_type, item.pack.nil? ? nil : item.pack.id,nil, self.date,true)
      line_items  <<  item
    end
  end

  def total_price
    line_items.to_a.sum do |item|
      price = item.weight_price == 0 ? item.price : item.weight_price
      price * item.recount
    end
  end

  def total_quantity
    line_items.to_a.sum { |item| item.total_quantity }
  end

end
