module LineItemsHelper
  def display_recount(number)
    unless number.nil?
      sprintf("%01.2f",number)
    end
  end

  def line_item_packs(line_item)
    return [] if line_item.product.is_folder

    Pack
      .joins('INNER JOIN products ON packs.product_id = products.unf_id')
      .where(products: { id: line_item.product.id })
      .where(deletion_mark: false, not_active: false)
      .where.not(id: 0)
  end

end
