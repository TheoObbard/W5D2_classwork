class PostsController < ApplicationController
  before_action :ensure_author, only: [:edit, :update]

  def show
    @post = Post.find_by(id: params[:id])
  end

  def new
    # fail

    @post = Post.new
    # @subs = Sub.all
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id
    @post.sub_ids = params[:post][:sub_ids]
    fail
    if @post.save
      redirect_to post_url(@post)
    else
      flash[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def update
    @post = Post.find_by(id: params[:id])
    # @post.sub_ids = params[:post][:sub_ids]
    # fail
    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  def ensure_author
    @post = Post.find_by(id: params[:id])
    unless @post.author == current_user
      redirect_to post_url(@post)
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    redirect_to sub_url(@post.sub)
  end

  private
  def post_params
    params.require(:post).permit(:title, :url, :content, sub_ids: [])
  end
end
