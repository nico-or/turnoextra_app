Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#home"
  get "about", to: "pages#about"
  get "faq", to: "pages#faq"

  resources :boardgames, only: %i[index show]
  resources :deals, only: %i[index]
  resources :stores, only: %i[index]
  resources :store_suggestions, only: %i[index new create]

  get "/contact", to: "contact_messages#new"
  post "/contact", to: "contact_messages#create"

  get "/contact/boardgame/:boardgame_id", to: "contact_messages#new_boardgame_error", as: :new_boardgame_error
  post "/contact/boardgame", to: "contact_messages#create_boardgame_error", as: :boardgame_errors

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "dashboard", to: "admin#index"

  namespace :admin, path: "dashboard" do
    resources :uploads, only: %i[new create]

    resources :stores
    resources :listings
    resources :boardgames

    resources :contact_messages, only: [ :index, :show ] do
      member do
        post "toggle_read"
      end
    end

    resources :identifications, only: [ :index, :new, :create ] do
        post "toggle_is_boardgame", on: :collection
    end
  end
end
