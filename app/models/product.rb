class Product < ApplicationRecord
  validates :title, :description, :image_url, presence: true
  # validates :price, numericality: {greate_than_or_equel_to: 0.01}
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png|jpeg)\Z}i,
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
  has_many :unit_products, dependent: :destroy
  has_many :product_exeptions
  attr_accessor :belong_another_client

  scope :roots, -> { where(parent_id: nil) }

  paginates_per 50
  max_paginates_per 100

  def self.get_price(prod_id, pricetype_id, pack_id = nil, product_unit_id = nil, period = nil)

    return 0 if pricetype_id.nil?

    period = if period.nil?
               Time.now
             else
               period
             end

    product_unit = if product_unit_id.nil?
                     default_unit(prod_id)
                   else
                     UnitProduct.find_by(id: product_unit)
                   end

    product_price = 0
    pack_price = 0

    # get product price
    if product_unit.nil?
      result = Price.all.where(product_id: prod_id, pricetype_id: pricetype_id).where('period <= ?', period).order(period: :DESC).limit(1)
    else
      result = Price.all.where(product_id: prod_id, pricetype_id: pricetype_id, unit_product_id: product_unit.id).where('period <= ?', period).order(period: :DESC).limit(1)
    end
    product_price = result[0].value unless result[0].nil?

    # get pack price
    unless pack_id.nil?
      result = Price.where(pack_id: pack_id).where('period <= ?', period).order(period: :DESC).limit(1)
      pack_price = result[0].value unless result[0].nil?
    end

    product_price + pack_price

  end

  def params_json_to_object(dat)

    self.unf_id = dat['unf_id']
    self.deletion_mark = dat['deletion_mark']
    self.not_active = dat['not_active']
    self.unf_parent_id = dat['unf_parent_id']
    self.title = dat['title']
    self.description = 'description'
    self.full_name = dat['full_name']
    self.order_id = dat['order_id']
    self.is_folder = dat['is_folder']
    self.parent_name = dat['parent_name']
    self.weight = dat['weight']
    self.rko = dat['rko']
    self.created_at = Time.now

    if dat['binary_file'] == ''
      self.image_url = 'image_url.jpg'
    else
      base64_image = dat['binary_file']
      # decode64
      img_from_base64 = Base64.decode64(base64_image)
      # file type
      filetype = dat['file_extension']
      # name the file
      filename = './app/assets/images/' + self.unf_id

      # write file
      file = filename << '.' << filetype
      File.open(file, 'wb') do |f|
        f.write(img_from_base64)
      end
      self.image_url = dat['unf_id'] + '.' + filetype
    end
    # end file
    #
    self.image_url = 'folder.jpg' if self.is_folder == true
  end

  def self.get_childs_product (parent_id)
    Product.where(:products => { is_folder: true, unf_parent_id: parent_id, not_active: false }).order("title")
  end

  def self.get_level (current_id)
    level = 1
    while current_id != "00000000017" do
      product = Product.find_by(unf_id: current_id)
      current_id = product.unf_parent_id
      level = level + 1
    end
    level
  end

  def self.default_unit(product_id)
    UnitProduct.find_by(product_id: product_id, default: true)
  end

  def belong_another_client (client_id)
    if client_id.nil?
      return false
    end
    res = ProductExeption.where(:product_id => self.id).where.not(:client_id => client_id)
    res.many?
  end

  # this method needs to rebuild
  def self.get_packs_product (product_id, favorite, client_id)
    # product pacs
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
       AND NOT pcs.deletion_mark
       AND NOT pcs.not_active'

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
