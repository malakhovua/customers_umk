class CustomerController < ApplicationController
  layout 'customer'
  include CurrentCart
  before_action :set_current_user
  before_action :set_cart
  before_action :set_clients
  before_action :set_client_id
  before_action :set_client
  before_action :set_price_type

  def products_content
    @products = fetch_products
    respond_to do |format|
      format.js
    end
  end

  def index
    @products = fetch_products
    @products_tree = products_tree('00000000017')

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
    return @clients = Client.none unless @current_user&.access_group_id.present?

    @clients = Client.where(access_group_id: @current_user.access_group_id).order(:name)
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
    scope.where('CONCAT(title, full_name) ILIKE ?', "%#{params[:Product_name]}%")
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


end