Rails.application.routes.draw do
  # Devise routes for user authentication, using custom controllers if needed
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # Routes for user profiles
  resources :users, only: [:edit, :update, :show] do
    member do
      # Route to send a friend request
      post :create_friendship, to: 'friendships#create'
      # Route to accept a friend request
      patch :accept_friendship, to: 'friendships#update'
      # Route to remove a friend
      delete :remove_friendship, to: 'friendships#destroy'
    end
  end

  # Custom route to access a user's profile using 'profile/:id' instead of 'users/:id'
  get 'profile/:id', to: 'users#show', as: 'profile'

  # RESTful routes for posts
  resources :posts

  # Custom route to remove a user's profile picture
  delete '/remove_profile_picture', to: 'users#remove_profile_picture', as: :remove_profile_picture

  # Define the root path
  root 'posts#index'
end
