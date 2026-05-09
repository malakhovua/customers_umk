class CustomerController < ApplicationController
  layout 'customer'
  include CurrentCart
  before_action :set_current_user
  before_action :set_cart
  before_action :set_clients
  before_action :set_client_id
  before_action :set_client
  before_action :set_price_type

  helper_method :clients_tree_html

  def products_content
    @show_as_cards = use_card_view?
    if @show_as_cards
      @products = fetch_products
    else
      fetch_list_data
    end
    respond_to do |format|
      format.js
    end
  end

  def index
    @show_as_cards = use_card_view?
    if @show_as_cards
      @products = fetch_products
      @products_tree = products_tree('00000000017')
    else
      fetch_list_data
    end
    update_cart_client if cart_client_changed?
  end

  private

  def set_price_type
    @price_type = @current_user&.pricetype || @client&.pricetype
  end

  private

  def set_current_user
    session[:user_id]
    @current_user = User.find_by(id: session[:user_id])
  end
  def set_clients
    if @current_user&.access_group_id.present?
      @clients = Client.where(access_group_id: @current_user.access_group_id).order(:name)
    else
      @clients = Client.order(:name)
    end
  end

  def set_client_id

    if @clients.size == 1
      @client_id = @clients[0].id
      return
    end

    @client_id = params[:client_id] || session[:client_id]
    session[:client_id] = @client_id
  end

  def set_client
    @client = Client.find_by(id: @client_id) if @client_id.present?
    @cart.update(client_id: @client_id)
  end

  def cart_client_changed?
    @cart.client_id != @client_id
  end

  def update_cart_client
    @cart.update(client_id: @client_id)
  end

  def fetch_products
    scope = base_product_scope
    scope = apply_filters(scope)
    scope.page(params[:page])
  end

  def use_card_view?
    if @current_user&.show_as_list_on_desktop?
      false
    elsif @current_user&.show_as_cards?
      true
    else
      !mobile_request?
    end
  end

  def mobile_request?
    if cookies[:mv].present?
      cookies[:mv] == '1'
    else
      request.user_agent.to_s =~ /Mobile|Android|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i
    end
  end

  def fetch_list_data
    @list_folders = Product.where(is_folder: true, not_active: false, deletion_mark: false)
                           .order(:title)
                           .to_a
    scope = Product.where(is_folder: false, deletion_mark: false, not_active: false)
    scope = filter_by_name(scope) if params[:Product_name].present?
    scope = filter_by_empty_pryce(scope)
    @list_products = scope.order(:title).to_a
  end

  def base_product_scope
    Product.where(is_folder: false, deletion_mark: false, not_active: false)
           .order("parent_name, title")
  end

  def apply_filters(scope)
    # Скинути фільтр категорій
    if params[:clear_categories].present?
      session[:selected_categories] = []
      return scope
    end
    scope = filter_by_favorite(scope) if params[:favorite] == "1"
    scope = filter_by_categories(scope) if params[:categories].present? || session[:selected_categories].present?
    scope = filter_by_name(scope) if params[:Product_name].present?
    scope = filter_by_empty_pryce(scope)
    scope
  end

  def filter_by_favorite(scope)
    scope.distinct
         .joins(:favorite_products)
         .where(favorite_products: { client_id: @client_id })
  end

  def filter_by_categories(scope)
    # Get categories from params or session
    if action_name == "index"
      categories = session[:selected_categories] || []
    else
      categories = params[:categories] || []
    end
    # Save categories to session for future use
    session[:selected_categories] = categories
    # Apply filter only if categories are present
    return scope if categories.empty?
    scope.where(unf_parent_id: categories)
  end

  def filter_by_name(scope)
    scope.where('CONCAT(title, full_name) ILIKE ?', "%#{params[:Product_name]}%")
  end

  def filter_by_empty_pryce(scope)
    return scope unless @price_type&.ignore_empty_prices?

    latest_prices_subquery = Price.joins(:unit_product)
                                  .where(pricetype_id: @price_type.id)
                                  .where("prices.period <= ?", Date.today)
                                  .where.not(value: [nil, 0])
                                  .where(unit_products: { default: true })
                                  .select("DISTINCT ON (prices.product_id) prices.product_id")
                                  .order("prices.product_id, prices.period DESC")

    scope.where(id: latest_prices_subquery)
  end
  def products_tree(parent_id)
    children = Product.where(is_folder: true, not_active: false)
                      .where(unf_parent_id: parent_id)
                      .order(:title)
    return '' if children.empty?

    str = '<ul class="nested">'
    children.each do |product|
      str << product_tree_item(product)
    end
    str << '</ul>'
    str.html_safe
  end

  def product_tree_item(product)
    # Check if checkbox was previously selected
    checked = checked_category?(product.unf_id) ? 'checked' : ''

    checkbox = "<input name=\"categories[]\" id=\"chbx_li_#{product.unf_id}\" type=\"checkbox\" value=\"#{product.unf_id}\" #{checked}>"
    icon = '<i class="fa fa-folder"></i>'

    if product_has_children(product.unf_id)
      "<li>#{checkbox}<span class=\"caret\">#{icon}#{product.title}</span>#{products_tree(product.unf_id)}</li>"
    else
      "<li>#{checkbox}#{icon}<label>#{product.title}</label></li>"
    end
  end

  def product_has_children(parent_id)
    Product.where(is_folder: true, not_active: false)
           .where(unf_parent_id: parent_id)
           .exists?
  end

  # Check if category is selected
  def checked_category?(category_id)
    session[:selected_categories] ||= []
    session[:selected_categories].include?(category_id.to_s)
  end

  def clients_tree_html
    return ''.html_safe if @clients.blank?
    all = @clients.to_a
    unf_set = all.map(&:unf_id).compact.to_set
    roots = all.select { |c| c.parent_id.blank? || !unf_set.include?(c.parent_id) }
    build_clients_subtree(roots, all)
  end

  def build_clients_subtree(nodes, all_clients)
    return ''.html_safe if nodes.empty?
    str = '<ul class="cpicker-list">'
    nodes.sort_by { |c| [c.is_folder ? 0 : 1, c.name.to_s.downcase] }.each do |client|
      escaped_name = CGI.escapeHTML(client.name.to_s)
      if client.is_folder
        children = all_clients.select { |c| c.parent_id == client.unf_id }
        str << %(<li class="cpicker-folder" data-unf-id="#{CGI.escapeHTML(client.unf_id.to_s)}">)
        str << %(<div class="cpicker-folder-row">)
        str << %(<i class="fa fa-caret-right cpicker-caret"></i>)
        str << %(<i class="fa fa-folder-o cpicker-folder-icon"></i>)
        str << %(<span class="cpicker-folder-name">#{escaped_name}</span>)
        str << %(</div>)
        str << build_clients_subtree(children, all_clients)
        str << %(</li>)
      else
        str << %(<li class="cpicker-item" data-id="#{client.id}" data-name="#{escaped_name}">)
        str << %(<i class="fa fa-building-o"></i><span>#{escaped_name}</span>)
        str << %(</li>)
      end
    end
    str << '</ul>'
    str.html_safe
  end

end