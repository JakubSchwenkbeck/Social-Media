class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :add_collaborator, :remove_collaborator]
  before_action :set_post, only: %i[show edit update destroy add_collaborator remove_collaborator]
  before_action :authorize_post, only: %i[edit update destroy add_collaborator remove_collaborator]
  before_action :set_mood_tags, only: [:index]

  def index
    @mood_tags = MoodTag.pluck(:name) # Assuming you have a MoodTag model with names
  
    @posts = Post.all
  
    # Apply Stylefilter if present
    if params[:Stylefilter].present? && params[:Stylefilter] != ''
      @posts = @posts.where(post_type: params[:Stylefilter])
    end
  
    # Apply Moodfilter if present
    if params[:Moodfilter].present? && params[:Moodfilter] != 'All'
      # Use LIKE query to check if the mood filter is part of the serialized JSON array
      @posts = @posts.where("mood_tags LIKE ?", "%\"#{params[:Moodfilter]}\"%")
    end
  
    # Order the posts in descending order by created_at
    @posts = @posts.all.order(created_at: :desc)
  end
  
  
  def new
    @post = current_user.posts.build
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: 'Post was successfully created.'
    else
      Rails.logger.debug "Post errors: #{@post.errors.full_messages}"
      render :new
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully deleted.'
  end

  def show
  end

  def add_collaborator
    user = User.find(params[:user_id])
    if current_user.friends_with?(user) && !@post.collaborators.include?(user)
      @post.add_collaborator(user)
      redirect_to @post, notice: "#{user.username} has been added as a collaborator."
    else
      redirect_to @post, alert: "Unable to add collaborator."
    end
  end

  def remove_collaborator
    user = User.find(params[:user_id])
    if @post.collaborators.include?(user)
      @post.remove_collaborator(user)
      redirect_to @post, notice: "#{user.username} has been removed as a collaborator."
    else
      redirect_to @post, alert: "Unable to remove collaborator."
    end
  end
  def standard_post?
    post_type == 'standard'
  end

  def storytelling_post?
    post_type == 'storytelling'
  end

  def gallery_post?
    post_type == 'gallery'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_post
    unless @post.user == current_user || @post.collaborators.include?(current_user)
      redirect_to @post, alert: "You are not authorized to edit this post."
    end
  end


  def post_params
    params.require(:post).permit(
      :title,
      :post_type,
      :content,
      :image,
      images: [], # For gallery posts
      collaborator_ids: [],
      mood_tags: [] # Permit mood_tags as an array
    )
  end
  def set_mood_tags
    @mood_tags = MoodTag.pluck(:name)
  end
end
