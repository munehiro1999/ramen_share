Rails.application.routes.draw do
  root "ramen_posts#index"

  get "signup", to: "users#new"
  post "users", to: "users#create"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  post "guest_login", to: "sessions#guest_login"

  resources :users, only: [:index, :show, :edit, :update] do
    member do
      get :my_posts # 自分の投稿
      get :liked_posts # いいねした投稿
    end
  end
  resources :ramen_posts

  resources :ramen_posts do
    # いいね機能をネスト
    resource :like, only: [:create, :destroy]
    # 個別画像削除用ルート編集画面にて
    member do
      delete 'delete_image/:image_id', to: 'ramen_posts#delete_image', as: 'delete_image'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

end
