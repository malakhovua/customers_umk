class Inventory < ApplicationRecord
  belongs_to :storage_place, optional: true
  belongs_to :user, optional: true
  has_many :inventory_line_items, dependent: :destroy
  enum status: %i[open closed]

  def recalculate_total_sum
    total_sum = inventory_line_items.to_a.sum(&:sum)
    self.sum = total_sum.nil? ? 0.0 : total_sum.to_f
  end

end


