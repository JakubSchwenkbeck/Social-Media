Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }

  # Routes for user profiles
  resources :users, only: [:edit, :update, :show] do
    member do
      post :send_friend_request, to: 'friendships#create'
      patch :accept_friend_request, to: 'friendships#accept'
      delete :ignore_friend_request, to: 'friendships#ignore'
      delete :remove_friend, to: 'friendships#destroy'
    end
  end

  # Custom route to access a user's profile using 'profile/:id' instead of 'users/:id'
  get 'profile/:id', to: 'users#show', as: 'profile'

  # RESTful routes for posts
  resources :posts do
    # Custom routes for adding and removing collaborators
    member do
      post :add_collaborator
      delete :remove_collaborator
    end
  end

  # Custom route to remove a user's profile picture
  delete '/remove_profile_picture', to: 'users#remove_profile_picture', as: :remove_profile_picture

  # Define the root path
  root 'posts#index'
end
