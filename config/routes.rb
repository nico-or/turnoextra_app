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

  get "faq", to: "pages#faq"

  get "sitemap", to: "sitemap#index", defaults: { format: "xml" }

  get "search", to: "search#search"

  resources :boardgames, only: %i[index show] do
    resources :messages, only: %i[new create], controller: :boardgame_messages
    member do
      get ":slug", action: :show, as: :slugged
    end
  end
  resources :deals, only: %i[index]
  resources :stores, only: %i[index]
  resources :store_suggestions, only: %i[new create]

  get "/contact", to: "contact_messages#new"
  post "/contact", to: "contact_messages#create"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "dashboard", to: "admin#index"

  namespace :admin, path: "dashboard" do
    mount MissionControl::Jobs::Engine, at: "/jobs"

    resources :uploads, only: %i[new create]

    resources :stores

    resources :listings do
      patch :identify, on: :member
      patch :unidentify, on: :member
    end

    resources :boardgames

    resources :store_suggestions, only: %i[index]

    resources :contact_messages, only: [ :index, :show ] do
      member do
        post "toggle_read"
        patch "mark_addressed"
      end
    end

    resources :identifications, only: [ :index, :new, :create ] do
        post "toggle_is_boardgame", on: :collection
    end

    namespace :reports do
      get "store_prices_count"
    end
  end
end
