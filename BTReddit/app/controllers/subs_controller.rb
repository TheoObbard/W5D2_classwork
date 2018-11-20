class SubsController < ApplicationController

  before_action :require_moderator_status, only: [:edit, :update, :destroy]

  def require_moderator_status
    unless current_user.is_moderator?(Sub.find_by(id: params[:id]))
      flash[:errors] = ["User doesn't have permissions to modify sub"]
      redirect_to subs_url
    end
  end

  def index
    @subs = Sub.all
  end

  def show
    @sub = Sub.find_by(id: params[:id])
  end

  def new
    @sub = Sub.new
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.moderator_id = current_user.id
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def edit
    @sub = Sub.find_by(id: params[:id])
  end

  def update
    @sub = Sub.find_by(id: params[:id])
    if @sub.update_attributes(sub_params)
      redirect_to sub_url(@sub)
    elsif
      flash[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  def destroy
    @sub = Sub.find_by(id: params[:id])
    @sub.destroy
    redirect_to subs_url
  end

  private

  def sub_params
    params.require(:sub).permit(:title, :description)
  end

end
