Rails.application.routes.draw do
  resource :user_location, only: %i(show edit update)

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :produces do
    resources :seasons, shallow: true, only: %i(create show destroy)
      resources :vouches, shallow: true, only: %i(create update)
    resources :links, except: %i(show edit update destroy index new create)
  end

  # Defines the root path route ("/"
  root "produces#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
