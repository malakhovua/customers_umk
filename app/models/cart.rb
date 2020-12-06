class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product(product, pack, qty, unit_id, pack_type_id)

    unit = Unit.find(unit_id)

    unless pack.nil?
      current_item = line_items.find_by(product_id: product.id, pack_id: pack.id, unit_id:unit_id)
    else
      current_item = line_items.find_by(product_id: product.id, unit_id:unit_id)
    end

    if current_item
      if unit.piece
        current_item.amount += qty
      else
        current_item.quantity += qty
      end
    else
      unless pack.nil?
        current_item = line_items.build(product_id: product.id, pack_id: pack.id, unit_id: unit_id, pack_type_id: pack_type_id, product_unf_id:product.unf_id)
      else
        current_item = line_items.build(product_id: product.id, unit_id: unit_id, product_unf_id:product.unf_id)
      end
      if unit.piece
        current_item.amount = qty
      else
        current_item.quantity = qty
      end
    end
    current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price (item.product.id) }
  end

  def total_quantity
    line_items.to_a.sum { |item| item.total_quantity }
  end

end
