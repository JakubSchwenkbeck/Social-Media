class ApplicationController < ActionController::Base
  # Configure the application to allow only modern browsers that support:
  # - WebP images
  # - Web push notifications
  # - Badges
  # - Import maps
  # - CSS nesting
  # - CSS :has() pseudo-class
  allow_browser versions: :modern

  # Before any action is processed, run the configure_permitted_parameters method
  # if the request is handled by Devise (a user authentication library).
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Configure additional permitted parameters for Devise sign-up and account update.
  # This allows users to provide their username, profile picture, and biography.
  def configure_permitted_parameters
    # Permit additional parameters for user sign-up.
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :profile_picture, :biography])
    
    # Permit additional parameters for user account update.
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :profile_picture, :biography])
  end
end
