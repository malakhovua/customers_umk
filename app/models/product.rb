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
  has_many :favorite_products, dependent: :destroy

  scope :roots, -> { where(parent_id: nil) }

  paginates_per 50
  max_paginates_per 100

  def self.get_price (prod_id=0, pricetype_id=22)
    text_query = 'SELECT
    pr.value,
    pr.product_id,
    pr.period
    FROM
    prices AS pr
    WHERE pr.product_id = %d
    AND pr.pricetype_id = %d
    LIMIT 1'
    text_query = sprintf(text_query,prod_id, pricetype_id)

    result = ActiveRecord::Base.connection.exec_query(text_query)

    if result[0].nil?
      0.to_f
    else
      result[0]['value'].to_f
    end

  end

  def self.get_childs_product (parent_id)
    Product.where(:products => {is_folder:true, unf_parent_id:parent_id}).order("title")
  end

  def self.get_packs_product (product_id, favorite, client_id)


    text_query = 'SELECT
       p.id,
       p.title,
       p.image_url,
       p.description,
       p.price,
		   p.parent_id,
		   perents.title AS parents_name,
       pcs.name AS pack_name,
       pcs.product_id,
       pcs.id as pack_id
       FROM products as p
       LEFT JOIN packs AS pcs ON p.unf_id = pcs.product_id
		   LEFT JOIN products AS perents ON p.parent_id = perents.id
		   WHERE p.is_folder = false
       AND NOT pcs.id = 0
	     AND p.id = %d
       AND pcs.deletion_mark = false'

    text_query = sprintf(text_query, product_id)
    result = ActiveRecord::Base.connection.exec_query(text_query)
    return result
  end


  private

  def ensure_not_ref_by_any_line_item
    unless line_items.empty?
      error.add(:base, 'Line Items present')
      throw :abort
    end
  end
end
