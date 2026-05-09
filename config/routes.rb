Rails.application.routes.draw do
  # 👇 ТОЛЬКО ОДИН root (главная страница)
  # Сейчас ведёт на работу (потом можно будет поменять на main)
  root 'work#index'

  # Маршруты для рабочей области (WorkController)
  get 'work', to: 'work#index'
  get 'choose_theme', to: 'work#choose_theme'
  post 'display_theme', to: 'work#display_theme'
  get 'next_image', to: 'work#next_image'
  get 'prev_image', to: 'work#prev_image'

  # Маршруты для главного меню (MainController)
  get 'main/index'
  get 'main/help'
  get 'main/contacts'
  get 'main/about'

  namespace :api do
    get 'next_image', to: 'api#next_image'
    get 'prev_image', to: 'api#prev_image'
  end

  # Ресурсы (CRUD для моделей)
  resources :themes
  resources :images
  resources :values
  resources :users

  # Health check (стандартный маршрут Rails)
  get "up" => "rails/health#show", as: :rails_health_check
end