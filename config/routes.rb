Rails.application.routes.draw do
  get 'admin' => 'admin#index'
  controller :payment_result do
    get 'payment_result/success' => :success, as: :payment_success
    get 'payment_result/failure' => :failure, as: :payment_failure
  end
  post 'back_requests' => 'back_requests#update'
  post 'charge_client' => 'charge_client#charge'
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  resources :users
  resources :products
  scope '(:locale)' do
    resources :orders
    resources :line_items
    resources :carts
    get 'payment' => 'payment#index'
    root 'store#index', as: 'store_index', via: :all
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
