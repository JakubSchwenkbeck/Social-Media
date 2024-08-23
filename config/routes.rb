Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # Define a route for user profiles
  resources :users, only: [:show]

  # Alternatively, a custom route
  get 'profile/:id', to: 'users#show', as: 'profile'

  # Define RESTful routes for posts, including the show action
  resources :posts, only: [:index, :new, :create, :show]

  # Define the root path
  root 'posts#index'
end
