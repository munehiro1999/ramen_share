class RamenPostsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
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

  # 1. 既存画像削除
  if params[:deleted_image_ids].present?
    params[:deleted_image_ids].each do |id|
      image = @ramen_post.images.find_by(id: id)
      image.purge if image
    end
  end

  # 2. 新規画像を追加
  if params[:ramen_post][:images].present?
    @ramen_post.images.attach(params[:ramen_post][:images])
  end

  # 3. その他のフォーム情報を更新
  if @ramen_post.update(ramen_post_params.except(:images))
    redirect_to ramen_posts_path, notice: "投稿を更新しました"
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
