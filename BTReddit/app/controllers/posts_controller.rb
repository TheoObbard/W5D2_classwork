class PostsController < ApplicationController
  before_action :ensure_author, only: [:edit, :update]

  def show
    @post = Post.find_by(id: params[:id])
  end

  def new
    @post = Post.new
    @sub = Sub.find_by(id: params[:sub_id])
  end

  def edit
    @post = Post.find_by(id: params[:id])
    @sub = Sub.find_by(id: params[:sub_id])
  end

  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id
    @post.sub_id = params[:sub_id]

    if @post.save
      redirect_to sub_post_url(@post.sub, @post)
    else
      flash[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def update
    @post = Post.find_by(id: params[:id])
    if @post.update_attributes(post_params)
      redirect_to sub_post_url(@post.sub, @post)
    else
      flash[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  def ensure_author
    @post = Post.find_by(id: params[:id])
    unless @post.author == current_user
      redirect_to sub_post_url(@post.sub, @post)
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    redirect_to sub_url(@post.sub)
  end

  private
  def post_params
    params.require(:post).permit(:title, :url, :content)
  end
end
