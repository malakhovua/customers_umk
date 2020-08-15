class Product < ApplicationRecord
  validates :title, :description, :image_url, presence: true
  #validates :price, numericality: {greate_than_or_equel_to: 0.01}
  validates :image_url, allow_blank: true, format: {
      with: %r{\.(gif|jpg|png)\Z}i,
      massege: 'must be a URL for GIF, JPG or PNG image.'
  }
  before_destroy :ensure_not_ref_by_any_line_item
  has_many :line_items
  has_many :orders, through: :line_items
  has_many :packs, class_name: 'Pack', foreign_key: :product_id_
  has_many :subs, class_name: 'Product', foreign_key: :parent_id
  belongs_to :superior, class_name: 'Product', foreign_key: :parent_id, optional: true
  has_many :price

  scope :roots, -> { where(parent_id: nil) }

private

def ensure_not_ref_by_any_line_item
  unless line_items.empty?
    error.add(:base, 'Line Items present')
    throw :abort
    end
  end
end
