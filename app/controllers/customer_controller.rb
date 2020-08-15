class CustomerController < ApplicationController
  include CurrentCart
  before_action :set_cart
  def index
    #@products = Product.order(:parent_id)

    text_query = 'SELECT
           p.id,
           p.title,
           p.image_url,
           p.description,
           p.price,
           pcs.name AS pack_name,
           pcs.product_id,
           pcs.id as pack_id
           FROM products as p
           LEFT JOIN packs AS pcs ON p.id = pcs.product_id
           WHERE p.is_folder = false
           ORDER BY p.id'

    result = ActiveRecord::Base.connection.exec_query(text_query)
    @products = result
  end
end
