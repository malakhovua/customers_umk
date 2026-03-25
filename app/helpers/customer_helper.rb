module CustomerHelper
  def product_packs(product)
    return [] if product.is_folder

    ignore_not_active_packs = @price_type&.ignore_not_active_packs? || false

    packs_scope = Pack
                    .joins('INNER JOIN products ON packs.product_id = products.unf_id')
                    .where(products: { id: product.id })
                    .where.not(deletion_mark: true)
                    .where.not(id: 0)

    packs_scope = packs_scope.where.not(not_active: true) unless ignore_not_active_packs

    packs_scope
  end
end
