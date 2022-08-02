Rails.application.routes.draw do
  post 'back_requests' => 'back_requests#update'
  post 'charge_clients' => 'charge_clients#charge'

  scope '(:locale)' do
    resources :carts
    resources :line_items
    resources :orders
    resources :products
    resources :users

    get 'admin' => 'admin#index'
    get 'payments' => 'payments#index'

    controller :payment_results do
      get 'payment_results/success' => :success, as: :payment_success
      get 'payment_results/failure' => :failure, as: :payment_failure
    end

    controller :sessions do
      get 'login' => :new
      post 'login' => :create
      delete 'logout' => :destroy
    end

    root 'store#index', as: 'store_index', via: :all
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
