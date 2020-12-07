Rails.application.routes.draw do

  resources :exch_nodes
  resources :units
  resources :favorite_products
  resources :prices
  resources :pricetypes
  resources :packs
  resources :orders
  resources :clients
  get 'account' => 'account#index'

  get 'admin' => 'admin#index'
  get 'admin/products_1c83' => 'admin#products_1c83', :as => :products_1c83
  get 'admin/packs_1c83' => 'admin#packs_1c83', :as => :packs_1c83
  get 'admin/clients_1c83' => 'admin#clients_1c83', :as => :clients_1c83
  get 'admin/pricetypes_1c83' => 'admin#pricetypes_1c83', :as => :pricetypes_1c83
  get 'admin/prices_1c83' => 'admin#prices_1c83', :as => :prices_1c83
  get 'admin/orders_to_1c83' => 'admin#orders_to_1c83', :as => :orders_to_1c83

  get "line_items/modal_product_qty" => 'line_items#modal_product_qty', :as => :modal_product_qty
  get "products/return_child_products" => 'products#return_child_products', :as => :return_child_products
  get "products/select_group_product" => 'products#select_group_product',   :as => :select_group_product


          controller :sessions do
    get 'login'=> :new
    post 'login'=> :create
    delete 'logout'=> :destroy
  end

  resources :line_items
  resources :carts
  resources :products
  resources :users

  root 'customer#index', as: 'customer_index'


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
