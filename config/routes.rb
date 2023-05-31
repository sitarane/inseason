Rails.application.routes.draw do
  resources :links
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_for :users
  resources :produces

  # Defines the root path route ("/")
  root "produces#index"
end
