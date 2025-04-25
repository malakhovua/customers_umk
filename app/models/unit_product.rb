class UnitProduct < ApplicationRecord
  belongs_to :product
  has_many :inventory_line_items
  has_many :prices

  def params_json_to_object(product, dat)
    self.unf_id = dat['unf_id']
    self.name = dat['name']
    self.deletion_mark = dat['deletion_mark']
    self.ratio = dat['ratio']
    self.default = dat['default']
    self.product_id = product.id
  end
end
