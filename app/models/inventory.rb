class Inventory < ApplicationRecord
  belongs_to :storage_place, optional: true
  belongs_to :user, optional: true
  has_many :inventory_line_items, dependent: :destroy
  enum status: %i[open closed]

  def recalculate_total_sum
    self.sum = 0.0 if sum.nil?
    self.sum = inventory_line_items.to_a.sum(&:sum).to_f
  end

end


