class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy
  belongs_to :client, optional: true

  def add_product(product, pack, qty, unit_id, pack_type_id, comment)

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
      if pack.nil?
        current_item = line_items.build(product_id: product.id, unit_id: unit_id, product_unf_id: product.unf_id, comment: comment)
      else
        current_item = line_items.build(product_id: product.id, pack_id: pack.id, unit_id: unit_id, pack_type_id: pack_type_id, product_unf_id: product.unf_id, comment: comment)
      end
      if unit.piece
        current_item.amount = qty
      else
        current_item.quantity = qty
      end
    end
    current_item.recount = current_item.total_quantity
    current_item
  end

  def has_line_item (product_id, pack_id)

    if pack_id.nil?
      pack = nil
    else
      pack = Pack.find(pack_id)
    end

    if pack.nil?
      current_item = line_items.find_by(product_id: product_id)
    else
      current_item = line_items.find_by(product_id: product_id, pack_id: pack_id)
    end

    if current_item
      true
    else
      false
    end
  end

  def total_price
    line_items.to_a.sum { |item| Product.get_price(item.product.id,self.client.pricetype.id, item.pack.nil? ? nil : item.pack.id) * (item.quantity + item.amount)}
  end

  def total_quantity
    line_items.to_a.sum { |item| item.total_quantity }
  end

end
