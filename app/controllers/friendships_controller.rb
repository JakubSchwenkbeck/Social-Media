class FriendshipsController < ApplicationController
  before_action :find_user, only: [:create, :accept, :destroy]

  def create
    if current_user.send_friend_request(@user)
      redirect_to @user, notice: "Friend request sent."
    else
      redirect_to @user, alert: "Unable to send friend request."
    end
  end

  def accept
    if current_user.accept_friend_request(@user)
      redirect_to @user, notice: "Friend request accepted."
    else
      redirect_to @user, alert: "Unable to accept friend request."
    end
  end

  def destroy
    if current_user.remove_friend(@user)
      redirect_to @user, notice: "Friend removed."
    else
      redirect_to @user, alert: "Unable to remove friend."
    end
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end
end
