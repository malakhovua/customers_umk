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

  # ── Ієрархічний список ──────────────────────────────────────────────────────

  def list_flat_html(products)
    html = String.new
    products.each do |product|
      next if product.belong_another_client(@client_id)
      html << list_product_html(product)
    end
    html.html_safe
  end

  def list_tree_html(parent_unf_id, folders_by_parent, products_by_parent)
    html = String.new

    (folders_by_parent[parent_unf_id] || []).each do |folder|
      children = list_tree_html(folder.unf_id, folders_by_parent, products_by_parent)
      next if children.blank?

      html << '<div class="plist-folder">'
      html << '<div class="plist-folder-row">'
      html << '<i class="fa fa-caret-right plist-caret"></i>'
      html << '<i class="fa fa-folder-o plist-folder-icon"></i>'
      html << "<span class=\"plist-folder-name\">#{ERB::Util.h(folder.title)}</span>"
      html << '</div>'
      html << '<div class="plist-folder-children">'
      html << children
      html << '</div></div>'
    end

    (products_by_parent[parent_unf_id] || []).each do |product|
      next if product.belong_another_client(@client_id)
      html << list_product_html(product)
    end

    html.html_safe
  end

  private

  def list_product_html(product)
    price_str = sprintf('%0.02f грн.', Product.get_price(product.id, @price_type))
    html = String.new

    html << '<div class="plist-product">'
    html << "<span class=\"plist-product__name\">#{ERB::Util.h(product.title)}</span>"
    html << "<span class=\"plist-product__price\">#{ERB::Util.h(price_str)}</span>"
    html << list_cart_btn(product.id, nil, product.title, '', 'кг', 'plist-btn')
    html << '</div>'

    product_packs(product).each do |pack|
      pack_price = sprintf('%0.02f грн.', Product.get_price(product.id, @price_type, pack.id))
      html << '<div class="plist-pack">'
      html << "<span class=\"plist-pack__name\"><i class=\"fa fa-level-down plist-pack__arrow\"></i>#{ERB::Util.h(pack.name)}</span>"
      html << "<span class=\"plist-pack__price\">#{ERB::Util.h(pack_price)}</span>"
      html << list_cart_btn(product.id, pack.id, product.title, pack.name, 'шт', 'plist-btn green')
      html << '</div>'
    end

    html.html_safe
  end

  def list_cart_btn(product_id, pack_id, product_name, pack_name, unit_name, css_class)
    icon = '<i class="fa fa-cart-plus"></i>'.html_safe
    if @client_id.nil?
      link_to('#', class: css_class, 'data-confirm': 'Оберіть замовника', remote: true) { icon }
    else
      link_to(modal_product_qty_path(id: product_id, pack_id: pack_id,
                product_name: product_name, pack_name: pack_name, unit_name: unit_name),
              class: css_class,
              'data-toggle': 'modal', 'data-target': '#modal-window',
              remote: true) { icon }
    end
  end
end
