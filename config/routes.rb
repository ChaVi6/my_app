Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  scope "(:locale)", locale: /ru|en/ do
    root 'main#index'

    get 'signup' => 'users#new'
    resource :session, only: [:new, :create, :destroy]
    resources :users, only: [:new, :create, :show]

    # Рабочая область
    get 'work', to: 'work#index'
    get 'work_summary', to: 'work#summary'
    get 'choose_theme', to: 'work#choose_theme'
    post 'display_theme', to: 'work#display_theme'

    # Статические страницы
    get 'main/help'
    get 'main/contacts'
    get 'main/about'

    # API для AJAX
    namespace :api do
      get 'next_image', to: 'api#next_image'
      get 'prev_image', to: 'api#prev_image'
      post 'save_value', to: 'api#save_value'
      get 'get_image_rating', to: 'api#get_image_rating'
    end

    # CRUD-ресурсы
    resources :themes
    resources :images
    resources :values
  end
end