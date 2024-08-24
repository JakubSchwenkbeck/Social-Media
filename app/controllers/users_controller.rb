class UsersController < ApplicationController
  # Display the user's profile. Fetch the user by ID and retrieve their posts.
  # Redirect to the root path with an alert if the user is not found.
  def show
    @user = User.find_by(id: params[:id])
    
    if @user.nil?
      # Redirect to the home page if the user is not found, with an alert message.
      redirect_to root_path, alert: "User not found."
    else
      # Retrieve and order the user's posts by creation date in descending order.
      @posts = @user.posts.order(created_at: :desc)
    end
  end

  # Remove the current user's profile picture if one is attached.
  # Redirect to the edit user registration path with a success notice.
  def remove_profile_picture
    if current_user.profile_picture.attached?
      current_user.profile_picture.purge
    end
    redirect_to edit_user_registration_path, notice: 'Profile picture removed successfully.'
  end

  # Define permitted parameters for user operations.
  # This includes username, email, biography, profile picture, and password fields.
  def user_params
    params.require(:user).permit(:username, :email, :biography, :profile_picture, :password, :password_confirmation)
  end

  def send_friend_request
    @friend = User.find(params[:id])
    if current_user.send_friend_request(@friend)
      redirect_to @friend, notice: "Friend request sent."
    else
      redirect_to @friend, alert: "Unable to send friend request."
    end
  end

  def accept_friend_request
    @user = User.find(params[:id])
    if current_user.accept_friend_request(@user)
      redirect_to @user, notice: "Friend request accepted."
    else
      redirect_to @user, alert: "Unable to accept friend request."
    end
  end

  def remove_friend
    @friend = User.find(params[:id])
    if current_user.remove_friend(@friend)
      redirect_to @friend, notice: "Friend removed."
    else
      redirect_to @friend, alert: "Unable to remove friend."
    end
  end

  # Update the user profile with the provided parameters.
  # Redirect to the user's profile page on success or re-render the edit form on failure.
  def update
    @user = User.find(params[:id])
    
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile updated successfully.'
    else
      # Render the edit form again if the update fails.
      render :edit
    end
  end
end
