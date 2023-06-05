Rails.application.routes.draw do
  devise_for :users
  resources :produces do
    resources :links
  end

  # Defines the root path route ("/")
  root "produces#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
