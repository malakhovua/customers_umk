class CustomerController < ApplicationController
  include CurrentCart
  before_action :set_cart

  def index

    @products = case params[:favorite]

                when "1"
                  if params[:group]
                    Product.where(:products => {is_folder: false}).order("parent_id").where(parent_id: params[:group]).joins(:favorite_products).where(["Products.id = Favorite_products.product_id"]).page params[:page]
                  elsif params[:Product_name]
                    Product.where('title ILIKE ?', "%#{params[:Product_name]}%").
                        where(:products => {is_folder: false}).order("parent_id").joins(:favorite_products).where(["Products.id = Favorite_products.product_id"]).page params[:page]
                  else
                    Product.where(:products => {is_folder: false}).order("parent_id").joins(:favorite_products).where(["Products.id = Favorite_products.product_id"]).page params[:page]
                  end
                else
                  if params[:group]
                    Product.where(:products => {is_folder: false}).order("parent_id").where(parent_id: params[:group]).page params[:page]
                  elsif params[:Product_name]
                    Product.where('title ILIKE ?', "%#{params[:Product_name]}%").
                        where(:products => {is_folder: false}).order("parent_id").page params[:page]
                  else
                    Product.where(:products => {is_folder: false}).order("parent_id").page params[:page]
                  end
                end

    @products_group = Product.where(:products => {is_folder: true}).order("id")
    @favorite_products =FavoriteProduct.all

  end

end
