class PostsController < ApplicationController
  # Ensure that users are authenticated before they can access the new and create actions.
  before_action :authenticate_user!, only: [:new, :create]

  # Set the @post instance variable for the show, edit, update, and destroy actions.
  before_action :set_post, only: %i[show edit update destroy]

  # List all posts in descending order of creation date.
  def index
    @posts = Post.all.order(created_at: :desc)
  end

  # Initialize a new post object for the current user.
  def new
    @post = current_user.posts.build
  end

  # Render the edit form for the post. The @post instance variable is already set by the before_action.
  def edit
    # @post is already set by the before_action
  end

  # Update the post with the permitted parameters. Redirect to the post's show page on success.
  # If the update fails, render the edit form again.
  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  # Create a new post with the permitted parameters and associate it with the current user.
  # Redirect to the index page on success. If saving fails, log the errors and render the new form.
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: 'Post was successfully created.'
    else
      # Log the errors for debugging purposes.
      Rails.logger.debug "Post errors: #{@post.errors.full_messages}"
      render :new
    end
  end

  # Destroy the post and redirect to the posts index page with a notice.
  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully deleted.'
  end

  # Display a single post. The @post instance variable is set by the before_action.
  def show
    @post = Post.find(params[:id])
  end

  private

  # Set the @post instance variable for actions that require it (show, edit, update, destroy).
  def set_post
    @post = Post.find(params[:id])
  end

  # Define permitted parameters for post creation and update.
  def post_params
    params.require(:post).permit(:title, :content, :image)
  end
end
