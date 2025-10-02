class RamenPostsController < ApplicationController
  def index
    @ramen_posts = RamenPost.all
  end

  def new
    @ramen_post = RamenPost.new
  end

  def create
    @ramen_post = current_user.ramen_posts.new(ramen_post_params)

    if @ramen_post.save
      redirect_to @ramen_post, notice: "投稿を作成しました"
    else
      render "new"
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
      render "edit"
    end
  end

  def destroy
    @ramen_post = current_user.ramen_posts.find(params[:id])
    @ramen_post.destroy
    redirect_to ramen_posts_path, notice: "投稿を削除しました"
  end


  private

  def ramen_post_params
    params.require(:ramen_post).permit(:title, :genre, :description, :image, :rating )
  end
end
