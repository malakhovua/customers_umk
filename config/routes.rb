Rails.application.routes.draw do

  resources :inventory_line_items
  resources :inventories
  resources :storage_places
  resources :access_groups
  resources :product_exeptions
  resources :unit_products
  resources :addresses
  resources :exch_nodes
  resources :units
  resources :favorite_products
  resources :prices
  resources :pricetypes
  resources :packs
  resources :orders
  resources :clients

  get 'account' => 'account#index'
  get 'asighnclients' => 'asighnclients#index'

  get 'admin' => 'admin#index'
  get 'admin/products_1c83' => 'admin#products_1c83', :as => :products_1c83
  get 'admin/packs_1c83' => 'admin#packs_1c83', :as => :packs_1c83
  get 'admin/clients_1c83' => 'admin#clients_1c83', :as => :clients_1c83
  get 'admin/pricetypes_1c83' => 'admin#pricetypes_1c83', :as => :pricetypes_1c83
  get 'admin/prices_1c83' => 'admin#prices_1c83', :as => :prices_1c83
  get 'admin/orders_to_1c83' => 'admin#orders_to_1c83', :as => :orders_to_1c83
  get 'admin/addresse_1c83' => 'admin#addresses_1c83', :as => :addresses_1c383
  get 'admin/access_groups_1c83'=>'admin#access_groups_1c83', :as => :access_groups_1c83
  get 'admin/product_exceptions_1c83' => 'admin#product_exceptions_1c83', :as => :product_exceptions_1c83


  get "line_items/modal_product_qty" => 'line_items#modal_product_qty', :as => :modal_product_qty
  get "products/return_child_products" => 'products#return_child_products', :as => :return_child_products
  post "products/return_subdirectory/:group_id/:top" => 'products#return_subdirectory', :as => :return_subdirectory
  get "products/select_group_product" => 'products#select_group_product',   :as => :select_group_product

  get "asighnclients/get_clients_list" => 'asighnclients#get_clients_list', :as => :get_clients_list
  post "asighnclients/set_user_for_clients_list" => 'asighnclients#set_user_for_clients_list', :as => :set_user_for_clients_list
  delete '/asighnclients/:id', to: 'asighnclients#destroy', :as => :delete_asighnclients

  namespace 'v1', defaults: {format: 'json'} do
    resources :products, only: %i[index show]
  end
  namespace 'v1' do
    resources :inventories, only: %i[show create]
  end


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
