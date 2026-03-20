class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product, optional: true
  belongs_to :pack, optional: true
  belongs_to :cart


  def total_quantity
    return 0 if unit_id.nil?

    unit = Unit.find_by(id: unit_id)
    return 0 if unit.nil?

    if unit.piece
      if pack.nil?
        return 0 if product.nil?
        amount * product[:weight]
      else
        amount * pack[:weight]
      end
    else
      quantity
    end
  end
end
