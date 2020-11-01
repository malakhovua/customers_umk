class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product(product, pack, qty, unit_id)

    unless pack.nil?
      current_item = line_items.find_by(product_id: product.id, pack_id: pack.id)
    else
      current_item = line_items.find_by(product_id: product.id)
    end

    if current_item
      current_item.quantity += qty
    else
      unless pack.nil?
        current_item = line_items.build(product_id: product.id, pack_id: pack.id, unit_id: unit_id)
        current_item.quantity = qty
      else
        current_item = line_items.build(product_id: product.id, unit_id: unit_id)
        current_item.quantity = qty
      end
    end
    current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price (item.product.id)}
  end

  def total_quantity
    line_items.to_a.sum { |item| item.total_quantity }
  end

end
