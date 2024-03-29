class CustomerController < ApplicationController
  include CurrentCart
  before_action :set_cart

  def index

    @favorite = false
    @price_type_id = nil


    if params[:favorite] == 1.to_s
      @favorite = true
    end

    if params[:client_id].nil?
      @client_id = @cart.client_id
    else
      @client_id = params['client_id'][/\{(.*?)\}/, 1].to_i unless params['client_id'] == ''
    end

    @products = case params[:favorite]

                when "1"
                  if params[:group_id] != "" and params[:group_id] != nil
                    Product.distinct(:Product).where(:products => { is_folder: false, deletion_mark: false, not_active: false}).order("unf_parent_id").where(unf_parent_id: params[:group_id]).joins(:favorite_products).where(["Products.id = Favorite_products.product_id  AND Favorite_products.client_id=#{@client_id}"]).page params[:page]
                  elsif params[:Product_name]
                    Product.distinct(:Product).where('CONCAT(title, full_name) ILIKE ?', "%#{params[:Product_name]}%").
                      where(:products => { is_folder: false, deletion_mark: false, not_active: false}).order("unf_parent_id").joins(:favorite_products).where(["Products.id = Favorite_products.product_id  AND Favorite_products.client_id=#{@client_id}"]).page params[:page]
                  else
                    Product.distinct(:Product).where(:products => { is_folder: false, deletion_mark: false, not_active: false}).order("unf_parent_id").joins(:favorite_products).where(["Products.id = Favorite_products.product_id AND Favorite_products.client_id=#{@client_id}"]).page params[:page]
                  end
                else
                  if params[:group_id] != "" and params[:group_id] != nil
                    Product.where(:products => { is_folder: false, deletion_mark: false, not_active: false}).order("unf_parent_id").where(unf_parent_id: params[:group_id]).page params[:page]
                  elsif params[:Product_name]
                    Product.where('CONCAT(title, full_name) ILIKE ?', "%#{params[:Product_name]}%").
                      where(:products => { is_folder: false, deletion_mark: false, not_active: false}).order("unf_parent_id").page params[:page]
                  else
                    Product.where(:products => { is_folder: false, deletion_mark: false, not_active: false}).order("unf_parent_id").page params[:page]
                  end
                end

    @products_group = Product.where(:products => { is_folder: true, not_active: false}).order("unf_id")
    @favorite_products = FavoriteProduct.all

    if @cart.client_id != @client_id
      @cart.client_id = @client_id
      @cart.save
      session[:client_id] = @client_id
      respond_to do |format|
        format.js
      end
    end

    unless @cart.client.nil? || @cart.client.pricetype.nil?
      @price_type_id = @cart.client.pricetype.id
    end


  end

end
