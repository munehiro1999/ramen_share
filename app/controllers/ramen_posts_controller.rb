class RamenPostsController < ApplicationController
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    if params[:type] == "popular"
      @ramen_posts = RamenPost.popular
    else
      @ramen_posts = RamenPost.all.order(created_at: :desc )
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def new
    @ramen_post = RamenPost.new
  end

  def create
    @ramen_post = current_user.ramen_posts.new(ramen_post_params)

    if @ramen_post.save
      redirect_to ramen_posts_path, notice: "投稿を作成しました"
    else
      render "new", status: :unprocessable_entity
    end
  end

  def show
    @ramen_post = RamenPost.find(params[:id])
  end

  def edit
    @ramen_post = current_user.ramen_posts.find(params[:id])
  end

  def update
    @ramen_post = current_user.ramen_posts.find(params[:id])
    if @ramen_post.update(ramen_post_params)
      redirect_to @ramen_post, notice: "投稿を更新しました"
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    @ramen_post = current_user.ramen_posts.find(params[:id])
    @ramen_post.destroy
    redirect_to ramen_posts_path, notice: "投稿を削除しました"
  end

  def delete_image
    @ramen_post = current_user.ramen_posts.find(params[:id])
    image = @ramen_post.images.find(params[:image_id])
    image.purge
    redirect_back fallback_location: edit_ramen_post_path(@ramen_post), notice: "画像を削除しました"
  end


  private

  def ramen_post_params
    params.require(:ramen_post).permit(:title, :genre, :description, :rating, :address, :latitude, :longitude, images: [])
  end

  def correct_user  #投稿者とログインのユーザーが一致してしなければリダイレクト
    ramen_post = RamenPost.find(params[:id])
    redirect_to ramen_posts_path, alert: "権限がありません" unless ramen_post.user == current_user
  end
end
