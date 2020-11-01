Rails.application.routes.draw do

  resources :units
  resources :favorite_products
  resources :prices
  resources :pricetypes
  resources :packs
  resources :orders
  resources :clients
  get 'account' => 'account#index'
  get "line_items/modal_product_qty" => 'line_items#modal_product_qty', :as => :modal_product_qty


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
