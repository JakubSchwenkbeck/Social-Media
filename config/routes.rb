Rails.application.routes.draw do
  # Devise routes for user authentication, using custom controllers if needed
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # Routes for user profiles:
  # - 'edit' and 'update' allow users to edit and update their profile information.
  # - 'show' allows users to view a profile.
  resources :users, only: [:edit, :update, :show] do
    # Friendship routes within the context of a user
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
  # The 'as: 'profile'' creates a named route 'profile_path' for this action.
  get 'profile/:id', to: 'users#show', as: 'profile'

  # RESTful routes for posts:
  # - Provides standard CRUD actions (index, show, new, create, edit, update, destroy) for posts.
  resources :posts

  # Custom route to remove a user's profile picture:
  # - Maps to the 'remove_profile_picture' action in the 'users' controller.
  # - The 'as: :remove_profile_picture' creates a named route 'remove_profile_picture_path'.
  delete '/remove_profile_picture', to: 'users#remove_profile_picture', as: :remove_profile_picture

  # Define the root path:
  # - Directs the root URL of the application to the 'index' action in the 'posts' controller.
  root 'posts#index'
end
