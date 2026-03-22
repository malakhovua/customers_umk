class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy
  belongs_to :client, optional: true
  belongs_to :user

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
    return 0 if self.client.nil? || self.client.pricetype.nil?

    line_items.to_a.sum do |item|
      next 0 if item.product.nil?
      next 0 if item.pack.nil? && item.recount.nil?

      price = Product.get_price(
        item.product.id,
        self.client.pricetype,
        item.pack.nil? ? nil : item.pack.id
      )
      price * (item.recount || 0)
    end
  end

  def total_quantity
    line_items.to_a.sum { |item| item.total_quantity rescue 0 }
  end

end
