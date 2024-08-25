class FriendshipsController < ApplicationController
  before_action :set_user, only: [:create, :accept, :ignore, :destroy]
  before_action :authenticate_user!

  # Send a friend request
  def create
    if current_user.sent_request_to?(@user)
      redirect_to @user, alert: 'Friend request already sent.'
    elsif current_user.pending_request_from?(@user)
      redirect_to @user, alert: 'Friend request already sent and awaiting acceptance.'
    elsif @user == current_user
      redirect_to @user, alert: "You can't send a friend request to yourself."
    else
      current_user.send_friend_request(@user)
      redirect_to @user, notice: 'Friend request sent.'
    end
  end

  # Accept a friend request
  def accept
    friendship = current_user.received_friendships.find_by(user: @user)
    if friendship
      friendship.update(status: :accepted)
      redirect_to @user, notice: 'Friend request accepted.'
    else
      redirect_to root_path, alert: 'Friend request not found.'
    end
  end

  # Ignore (delete) a friend request
  def ignore
    friendship = current_user.received_friendships.find_by(user: @user)
    if friendship
      friendship.destroy
      redirect_to @user, notice: 'Friend request ignored.'
    else
      redirect_to root_path, alert: 'Friend request not found.'
    end
  end

  # Remove a friend
  def destroy
    if current_user.friends_with?(@user)
      current_user.remove_friend(@user)
      redirect_to @user, notice: 'Friend removed.'
    else
      redirect_to @user, alert: 'No friendship exists to remove.'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
