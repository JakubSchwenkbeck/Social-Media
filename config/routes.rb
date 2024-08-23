Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # Define a route for user profiles
  resources :users, only: [:edit, :update, :show]

  # Alternatively, a custom route
  get 'profile/:id', to: 'users#show', as: 'profile'

  # Define RESTful routes for posts, including the show action
 # resources :posts, only: [:index, :new, :create, :show]
  resources :posts

  # Add this route inside your Rails routes configuration
#delete 'remove_profile_picture', to: 'users#remove_profile_picture', as: 'remove_profile_picture'
delete '/remove_profile_picture', to: 'users#remove_profile_picture', as: :remove_profile_picture

  # Define the root path
  root 'posts#index'
end
