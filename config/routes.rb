Rails.application.routes.draw do
  resource :user_location, only: %i(show edit update)

  devise_for :users

  resources :produces do
    resources :seasons, shallow: true
      resources :vouches, shallow: true, only: %i(create show update)
    resources :links, except: %i(show edit update destroy index new create)
  end

  # Defines the root path route ("/"
  root "produces#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
