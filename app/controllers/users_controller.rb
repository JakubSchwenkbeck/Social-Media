class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      redirect_to root_path, alert: "User not found."
    else
      @posts = @user.posts.order(created_at: :desc)
    end
  end
end
