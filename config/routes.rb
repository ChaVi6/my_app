Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  scope "(:locale)", locale: /ru|en/ do
    get 'sessions/new'
    get 'sessions/create'
    get 'sessions/destroy'

    root 'main#index'

    get 'signup' => 'users#new'
    resource :session, only: [:new, :create, :destroy]
    resources :users, only: [:new, :create, :show]

    # Маршруты для рабочей области
    get 'work', to: 'work#index'
    get 'choose_theme', to: 'work#choose_theme'
    post 'display_theme', to: 'work#display_theme'
    get 'next_image', to: 'work#next_image'
    get 'prev_image', to: 'work#prev_image'

    # НОВЫЙ МАРШРУТ для общей сводки
    get 'work_summary', to: 'work#summary'

    # Маршруты для главного меню
    get 'main/index'
    get 'main/help'
    get 'main/contacts'
    get 'main/about'

    namespace :api do
      get 'next_image', to: 'api#next_image'
      get 'prev_image', to: 'api#prev_image'
      post 'save_value', to: 'api#save_value'
      get 'get_image_rating', to: 'api#get_image_rating'
    end

    resources :themes
    resources :images
    resources :values
    resources :users
  end
end