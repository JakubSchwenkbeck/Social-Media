class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      redirect_to root_path, alert: "User not found."
    else
      @posts = @user.posts.order(created_at: :desc)
    end
  end
  def remove_profile_picture
    current_user.profile_picture.purge if current_user.profile_picture.attached?
    redirect_to edit_user_registration_path, notice: 'Profile picture removed successfully.'
  end
end
