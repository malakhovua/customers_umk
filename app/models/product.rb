class Product < ApplicationRecord
  validates :title, :description, :image_url, presence: true
  # validates :price, numericality: {greate_than_or_equel_to: 0.01}
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png|jpeg)\Z}i,
    massege: 'must be a URL for GIF, JPG or PNG image.'
  }
  before_destroy :ensure_not_ref_by_any_line_item
  scope :folders, -> { where(is_folder: true) }
  scope :active, -> { where(not_active: false) }
  scope :not_deleted, -> { where(deletion_mark: false) }

  has_many :favorite_products
  has_many :line_items
  has_many :orders, through: :line_items
  has_many :packs, class_name: 'Pack', foreign_key: :product_id
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

  def self.get_price(prod_id, price_type, pack_id = nil, product_unit_id = nil, period = nil)
    return 0 if price_type.blank?

    period ||= Time.current
    product_unit = product_unit_id ? UnitProduct.find_by(id: product_unit_id) : default_unit(prod_id)

    # Ціна продукту
    product_scope = Price.where(product_id: prod_id, pricetype_id: price_type.id)
    product_scope = product_scope.where(unit_product_id: product_unit.id) if product_unit
    product_price = product_scope.where('period <= ?', period)
                                 .order(period: :desc)
                                 .limit(1)
                                 .first&.value || 0

    # Ціна упаковки
    pack_price = if pack_id
                   Price.where(pack_id: pack_id)
                        .where('period <= ?', period)
                        .order(period: :desc)
                        .limit(1)
                        .first&.value || 0
                 else
                   0
                 end

    product_price + pack_price
  end

  private

  def ensure_not_ref_by_any_line_item
    unless line_items.empty?
      error.add(:base, 'Line Items present')
      throw :abort
    end
  end
end




