module CustomerHelper
  def product_packs(product)
    return [] if product.is_folder

    Pack
      .joins('INNER JOIN products ON packs.product_id = products.unf_id')
      .where(products: { id: product.id })
      .where.not(deletion_mark: true)
      .where.not(not_active: true)
      .where.not(id: 0)
  end
end
