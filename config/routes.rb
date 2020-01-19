Rails.application.routes.draw do

  get 'account' => 'account#index'

  controller :sessions do
    get 'login'=> :new
    post 'login'=> :create
    delete 'logout'=> :destroy
  end

  resources :line_items
  resources :carts
  resources :products
  resources :users
  root 'castomer#index', as: 'castomer_index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
