class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :remove_profile_picture, :send_friend_request, :accept_friend_request, :remove_friend]

  def show
    @posts = @user.posts.order(created_at: :desc)
  end

  def remove_profile_picture
    if current_user.profile_picture.attached?
      current_user.profile_picture.purge
    end
    redirect_to edit_user_registration_path, notice: 'Profile picture removed successfully.'
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile updated successfully.'
    else
      render :edit
    end
  end

  def send_friend_request
    if current_user.send_friend_request(@user)
      redirect_to @user, notice: "Friend request sent."
    else
      redirect_to @user, alert: "Unable to send friend request."
    end
  end

  def accept_friend_request
    if current_user.accept_friend_request(@user)
      redirect_to @user, notice: "Friend request accepted."
    else
      redirect_to @user, alert: "Unable to accept friend request."
    end
  end

  def remove_friend
    if current_user.remove_friend(@user)
      redirect_to @user, notice: "Friend removed."
    else
      redirect_to @user, alert: "Unable to remove friend."
    end
  end

  private

  
  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    sign_out_and_redirect(current_user) if user_signed_in?
    redirect_to root_path, alert: "User not found. You have been signed out."
  end

  def sign_out_and_redirect(user)
    sign_out user
    # Perform redirect after signing out
  end

  def user_params
    params.require(:user).permit(:username, :email, :biography, :profile_picture, :password, :password_confirmation)
  end
end
